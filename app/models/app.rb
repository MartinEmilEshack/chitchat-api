class App < ApplicationRecord
	has_many :chats
	attr_accessor :token
end
