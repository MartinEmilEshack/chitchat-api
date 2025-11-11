class App < ApplicationRecord
  has_many :chats, dependent: :destroy
  attr_accessor :token
end
