# config/initializer/elasticsearch.rb
require 'elasticsearch'

module ElasticsearchClinet
	class Repository
		include Elasticsearch::Persistence::Repository
		include Elasticsearch::Persistence::Repository::DSL

		client Elasticsearch::Client.new (
			host: ENV['SEARCH_HOST'],
			port: ENV['SEARCH_PORT'],
			password: ENV['SEARCH_PASSWORD'] 
		)
			# url: 'http://:9200'
			# host_url: 'http://elasticsearch:9200',
			# hostname: 'http://elasticsearch:9200',
			# host: 'http://elasticsearch:9200',
			# port: '9200',
			# schema: 'http',
			# http: { scheme: 'http' },
			# hosts: [
  	  #  	{
    	#  	  host: 'chitchat-search',
    	#  	  port: '9200',
    	#  	  scheme: 'http'
  	  #  	}
			# ]
	end
end
