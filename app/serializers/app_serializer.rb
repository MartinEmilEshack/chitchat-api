class AppSerializer < ActiveModel::Serializer
  attributes :id, :name, :token, :chat_count
end
