require 'fileutils'
require 'geocoder'
require 'httparty'
require 'pry'

module Telescope
  module Notifier
    class << self
      def welcome
        self.send_alert('Welcome to Telescope! I\'ll notify you whenever something interesting happens with Snapchat Spectacles.')
      end

      def coordinates(coordinate)
        if coordinate.nil? || coordinate.length == 0
          raise ArgumentError.new('Coordinate must be in format \'lat,long\' and cannot be empty.')
        end

        place = Geocoder.search(coordinate)[0]

        place_string = if place.country_code == 'US'
          "near #{place.city}, #{place.state_code}"
        else
          "in #{place.country}"
        end

        self.send_alert("✨ Here we go! Snapbot is now located #{place_string}. See more here: https://spectacles.com/map")
      end

      def send_alert(text)
        unless Telescope::CONFIG[:telescope_env] == Telescope::PRODUCTION_ENV
          puts "\tSending message: '#{text}'"
          return
        end

        response = HTTParty.post(
          Telescope::CONFIG[:till_url],
          body: {
            phone: Telescope::CONFIG[:phone],
            text: text,
          }.to_json,
        )
      end
    end
  end
end
