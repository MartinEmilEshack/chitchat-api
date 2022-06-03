class ApplicationController < ActionController::API
	private
	def hmac_secret
		ENV["JWT_SECRET"]
	end

	def token(app_id:, redis_host:)
		payload = { app_id: app_id, redis_host: redis_host }
		JWT.encode(payload, hmac_secret, 'HS256')
	end


	def client_has_valid_token?
		!!app_payload
	end

	def app_payload
		begin
		  token = params[:token]
		  decoded_array = JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' })
		  decoded_array.first.deep_symbolize_keys
		rescue #JWT::VerificationError
		  return nil
		end
	end
end
