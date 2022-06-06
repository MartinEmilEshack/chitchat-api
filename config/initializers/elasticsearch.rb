# config/initializer/elasticsearch.rb
require 'elasticsearch'

# config = {
#   transport_options: { request: { timeout: 5 } }
# }
# if File.exist?('config/elasticsearch.yml')
#   template = ERB.new(File.new('config/elasticsearch.yml').read)
#   processed = YAML.safe_load(template.result(binding))
#   config.merge!(processed[Rails.env].symbolize_keys)
# end

module ElasticsearchClinet
	class Repository
		include Elasticsearch::Persistence::Repository
		include Elasticsearch::Persistence::Repository::DSL

		client Elasticsearch::Client.new
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
		# })
	end
end
