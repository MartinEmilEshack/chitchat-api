class AppSerializer < ActiveModel::Serializer
	attributes :name, :chat_count
	attribute :token, if: -> { object.token.present? }
end
