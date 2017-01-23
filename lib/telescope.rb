require 'httparty'
require 'telescope/configuration'
require 'telescope/db'
require 'telescope/notifier'
require 'telescope/status'

module Telescope
  SPECTACLES_URL = 'https://www.spectacles.com/locations'.freeze

  class << self
    def run
      puts '🔭  Searching for spectacles...'
      current_status = Telescope::Status.get_status
      previous_status = Telescope::Status.previous_status

      if !current_status[:coordinates].nil? && current_status[:coordinates].length > 0
        new_coordinates = self.filter_old_coordinates(current_status[:coordinates], previous_status[:coordinates])
        new_coordinates.each do |coord|
          puts "\t📬  Sending an alert for #{coord}"
          Telescope::Notifier.coordinates(coord)
        end
      end

      self.db.update_status(current_status)

      puts '🌈  All done'
    end

    def filter_old_coordinates(current_coordinates, previous_coordinates)
      current_coordinates ||= []
      previous_coordinates ||= []
      current_coordinates.select { |coord| !previous_coordinates.include? coord }
    end

    def db
      @db ||= Telescope::DB.new
    end
  end
end
