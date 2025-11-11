class MessageSerializer
  include JSONAPI::Serializer

  attributes :num, :text

  def self.json(messages)
    serialized = new(messages).serializable_hash
    if serialized[:data].is_a?(Array)
      serialized[:data].map { |d| d[:attributes] }
    else
      serialized[:data][:attributes]
    end
  end
end
