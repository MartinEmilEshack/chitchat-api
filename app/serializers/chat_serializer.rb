class ChatSerializer < ActiveModel::Serializer
  attributes :num, :message_count
end
