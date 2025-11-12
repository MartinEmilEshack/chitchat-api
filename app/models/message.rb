class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  before_validation :set_app_id

  belongs_to :chat
  belongs_to :app, foreign_key: :app_id, optional: true

  settings do
    mapping dynamic: false do
      indexes :text, type: :text, analyzer: "standard"
      indexes :chat_id, type: :integer
      indexes :app_id, type: :integer
    end
  end

  def self.filtered_search(text: nil, chat: nil)
    conditions = []
    conditions << { regexp: { text: ".*#{Regexp.escape(text)}.*" } } if text.present?
    conditions << { term:  { chat_id: chat.id } } if chat.present?
    conditions << { term:  { app_id: chat[:app_id] } } if chat.present?

    search({
      query: {
        bool: { must: conditions }
      }
    }).records
  end

  private
    def set_app_id
      self.app_id ||= chat.app_id if chat
    end
end
