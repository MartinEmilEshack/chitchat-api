module TokenHelper
  require "base64"

  KEY = Rails.application.secret_key_base.byteslice(0..31)
  CRYPT = ActiveSupport::MessageEncryptor.new(KEY)

  module_function

  def generate_token(app_id:, redis_host:)
    encrypted = CRYPT.encrypt_and_sign("#{app_id}:#{redis_host}")
    urlsafe_encode(encrypted)
  end

  def decode_token(token:)
    decoded = urlsafe_decode(token)
    decrypted = CRYPT.decrypt_and_verify(decoded)
    app_id, redis_host = decrypted.split(":", 2)

    { app_id: app_id.to_i, redis_host: redis_host }
  end

  def urlsafe_encode(str)
    Base64.urlsafe_encode64(str).tr("=", "")
  end

  def urlsafe_decode(str)
    padding = "=" * ((4 - str.length % 4) % 4)
    Base64.urlsafe_decode64(str + padding)
  end
end
