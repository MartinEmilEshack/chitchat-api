class AppSerializer
  include JSONAPI::Serializer

  attributes :name, :chat_count, :created_at, :updated_at, :token

  attribute :token, if: Proc.new { |record, params|
    params && params[:show_token]
  } do |app, params|
    TokenHelper.generate_token(app_id: app.id, redis_host: app.redis_host)
  end

  def self.json(apps, show_token: false)
    serialized = new(apps, params: { show_token: show_token }).serializable_hash
    if serialized[:data].is_a?(Array)
      serialized[:data].map { |d| d[:attributes] }
    else
      serialized[:data][:attributes]
    end
  end
end
