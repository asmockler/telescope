require 'mongo'

module Telescope
  class DB
    attr_accessor :client

    def initialize
      Mongo::Logger.logger.level = ::Logger::FATAL
      self.client = Mongo::Client.new(ENV['MONGODB_URI'])
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
      self.client[:status].update_one({_id: record[:_id]}, record)
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
