class MessagesWorker
	include Sneakers::Worker

	from_queue 'messages', env: nil

	def work(raw_message)
		begin
			message_data = JSON.parse(raw_message).with_indifferent_access
			chat = Chat.find_by! num: message_data[:chat_num], app_id: message_data[:app_id]
	
			message = Message.new num: message_data[:num], text: message_data[:text], chat_id: chat.id
			chat.update message_count: chat.message_count + 1
			message.save
	
			MessageRepository.init.save SearchableMessage.new( 
				num: message.num,
				text: message.text,
				chat_id: chat.id,
				app_id: chat.app_id
			)
			ack!
		rescue Exception => e
			Rails.logger.info ENV['SEARCH_HOST']
			Rails.logger.error e
		end
	end
end