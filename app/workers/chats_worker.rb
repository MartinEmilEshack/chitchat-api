class ChatsWorker
	include Sneakers::Worker

	from_queue 'chats', env: nil

	def work(raw_chat)
		chat = Chat.new JSON.parse(raw_chat)
		chat.save
		ack!
	end
end