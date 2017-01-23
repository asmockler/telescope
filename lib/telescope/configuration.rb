module Telescope
  PRODUCTION_ENV = 'production'

  CONFIG = {
    lat: ENV['LAT'],
    long: ENV['LONG'],
    phone: ENV['PHONE'].split(/[^0-9]/).join,
    till_url: ENV['TILL_URL'],
    telescope_env: ENV['TELESCOPE_ENV'] || PRODUCTION_ENV,
    mongo_uri: ENV['MONGODB_URI'] || ENV['MONGO_URI']
  }
end
