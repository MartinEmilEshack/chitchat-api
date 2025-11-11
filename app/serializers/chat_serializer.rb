class ChatSerializer
  include JSONAPI::Serializer

  attributes :num, :message_count

  def self.json(chats)
    serialized = new(chats).serializable_hash
    if serialized[:data].is_a?(Array)
      serialized[:data].map { |d| d[:attributes] }
    else
      serialized[:data][:attributes]
    end
  end
end
