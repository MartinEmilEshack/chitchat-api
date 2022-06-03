class AppSerializer < ActiveModel::Serializer
  attributes :name, :token, :chat_count
end
