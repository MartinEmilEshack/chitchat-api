class MessageRepository < ElasticsearchClinet::Repository
  include Singleton

	klass SearchableMessage
  index_name 'messages'
  document_type 'message'

	settings do
    mapping do
      indexes :num, index: false
      indexes :chat_id, type: 'keyword'
      indexes :app_id, type: 'keyword'
      indexes :text
    end
  end

  def self.init
    repo = self.instance
    repo.create_index!
    Rails.logger.info ENV['SEARCH_HOST']
  end
end