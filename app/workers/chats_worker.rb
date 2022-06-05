class ChatsWorker
	include Sneakers::Worker

	from_queue 'chats', env: nil

	def work(raw_chat)
		chat = Chat.new JSON.parse(raw_chat)
		app = App.find(chat.app_id)
		app.update chat_count: app.chat_count + 1
		chat.save
		ack!
	end
end