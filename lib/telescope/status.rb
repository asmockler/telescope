require 'mongo'

module Telescope
  module Status
    NO_INFO = 'No info'.freeze
    COUNTING_DOWN = 'Counting down'.freeze
    LOCATION_PRESENT = 'Location present'.freeze
    DEFAULT_STATUS = {
      status: NO_INFO,
      coordinates: nil,
      countdown: nil,
    }

    class << self
      def get_status
        response = HTTParty.get(Telescope::SPECTACLES_URL)

        status = if response['countdown'] > 0
          Telescope::Status::COUNTING_DOWN
        elsif response['coordinates']
          Telescope::Status::LOCATION_PRESENT
        else
          Telescope::Status::NO_INFO
        end

        coordinates = response['coordinates'].map { |coord| "#{coord["lat"]},#{coord["lng"]}" }

        {
          status: status,
          coordinates: coordinates,
          countdown: response['countdown'],
        }
      end

      def previous_status
        @previous_status ||= Telescope.db.status
      end
    end
  end
end
