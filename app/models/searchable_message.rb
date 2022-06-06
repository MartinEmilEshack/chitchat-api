class SearchableMessage
	attr_accessor :num
	attr_accessor :chat_id
	attr_accessor :app_id
	attr_accessor :text

	def initialize(num:, chat_id:, app_id:, text:)
    @num = num
		@chat_id = chat_id
		@app_id = app_id
		@text = text
  end

  def to_hash
		{ num: num, chat_id: chat_id, app_id: app_id, text: text }
  end
end