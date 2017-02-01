require 'mongo'
require 'geocoder'

module Telescope
  module Location
    class << self
      def parse_location(location)
        place = Geocoder.search([location["lat"], location["long"]])[0]

        unless place.city.nil?
          location["name"] = "#{place.city}, #{place.state_code}"
        else
          location = nil
        end

        location
      end
    end
  end
end
