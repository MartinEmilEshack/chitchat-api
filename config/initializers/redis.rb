# frozen_string_literal: true
require "redis"

begin
	REDIS = ConnectionPool.new(size: ENV['CACHE_MAX_THREADS']) do
		Redis.new(host: ENV['CACHE_HOST'], port: ENV['CACHE_PORT'], password: ENV['CACHE_PASSWORD'])
	end
rescue Exception => e
	puts e
	Rails.logger.info e
end
