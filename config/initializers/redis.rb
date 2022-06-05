# frozen_string_literal: true
require "redis"

module RedisCache
	class RedisConnection
		include Singleton
		attr_reader :connection 
		
		def initialize
			begin
				@connection ||= ConnectionPool.new(size: ENV['RAILS_MAX_THREADS']) do
					Redis.new(host: ENV['CACHE_HOST'], port: ENV['CACHE_PORT'], password: ENV['CACHE_PASSWORD'])
				end
			rescue Exception => e
				Rails.logger.info e
			end
		end
	end

	def cache
		RedisConnection.instance.connection
	end
end
