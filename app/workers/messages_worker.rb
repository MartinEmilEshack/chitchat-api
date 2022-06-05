class MessagesWorker
	include Sneakers::Worker

	from_queue 'messages', env: nil

	def work(raw_message)
		message = Message.new JSON.parse(raw_message)
		chat = Chat.find message.chat_id
		chat.update message_count: chat.message_count + 1
		message.save
		ack!
	end
end