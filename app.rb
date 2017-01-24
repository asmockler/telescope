require 'dotenv'
require 'sinatra'

Dotenv.load

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require 'telescope'

configure do
  DB = Telescope::DB.new
end

get "/" do
  @current_location = DB.location
  erb :index
end

post "/" do
  request.body.rewind
  data = JSON.parse(request.body.read)
  location = Telescope::Location.parse_location(data)
  
  unless location.nil?
    DB.update_location(location)
    status 200
    return
  else
    puts "invalid location"
    halt 500
  end
end

__END__

@@ index
<html>
  <head>
    <script>
      function updateLocation() {
        navigator.geolocation.getCurrentPosition(function(location) {
          var xhr = new XMLHttpRequest();
          xhr.open('POST', '/');
          xhr.setRequestHeader('Content-Type', 'application/json');
          xhr.onload = function() {
            if (xhr.status === 200) {
              window.location.reload(false);
            }
          };
          xhr.send(JSON.stringify({
            lat: location.coords.latitude,
            long: location.coords.longitude
          }));
        });
      }
    </script>
  </head>
  <body>
    <h1>Current Location: <%= @current_location["name"] %></h1>
    <button onclick="updateLocation()">Update Location</button>
  </body>
</html>
