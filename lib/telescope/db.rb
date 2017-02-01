require 'mongo'

module Telescope
  class DB
    attr_accessor :client

    def initialize
      Mongo::Logger.logger.level = ::Logger::FATAL
      self.client = Mongo::Client.new(Telescope::CONFIG[:mongo_uri])
    end

    def status
      return @status if @status

      if self.client[:status].count == 0
        self.client[:status].insert_one(Telescope::Status::DEFAULT_STATUS)
        Telescope::Notifier.welcome
      end

      self.client[:status].find.first
    end

    def update_status(new_status)
      record = self.status
      record.update(new_status)
      update = self.client[:status].update_one({_id: record[:_id]}, record)

      if update.modified_count == 1
        @status = record
      else
        puts "Status update failed. Status: #{record}"
        @status = nil
      end
      @status
    end

    def location
      return @location if @location

      if self.client[:location].count == 0
        self.client[:location].insert_one({lat: 0, long: 0})
      end

      @location = self.client[:location].find.first
    end

    def update_location(new_location)
      record = self.location
      record.update(new_location)
      update = self.client[:location].update_one({_id: record[:_id]}, record)
      
      if update.modified_count == 1
        @location = record
      else
        puts "Location update failed. Location: #{record}"
        @location = nil
      end
      @location
    end

    class << self
      def destroy_all_statuses
        puts "\t🔥  Destroying all statuses"
        Mongo::Logger.logger.level = ::Logger::FATAL
        client = Mongo::Client.new(ENV['MONGODB_URI'])
        client[:status].find.delete_many
        puts "\t💦  Database is clean"
      end
    end
  end
end
