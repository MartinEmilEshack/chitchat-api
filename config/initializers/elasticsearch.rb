require "elasticsearch/model"

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV.fetch("SEARCH_HOST", "http://localhost:9200"),
  log: true
)
