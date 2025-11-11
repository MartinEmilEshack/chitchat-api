# frozen_string_literal: true

module RabbitMQ
  class RabbitConnection
    include Singleton
    attr_reader :connection

    def initialize
      begin
        @connection = Bunny.new(
          host: ENV["QUEUE_HOST"],
          port: ENV["QUEUE_PORT"],
          user: ENV["QUEUE_USER"],
          pass: ENV["QUEUE_PASSWORD"]
        )
        @connection.start
      rescue Exception => e
        Rails.logger.info e
      end
    end

    def channel
      @channel ||= ConnectionPool.new(size: ENV["RAILS_MAX_THREADS"]) do
        connection.create_channel
      end
    end
  end

  def queue
    RabbitConnection.instance.channel
  end
end
