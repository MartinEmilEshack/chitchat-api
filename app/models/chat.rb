class Chat < ApplicationRecord
	belongs_to :app
	has_many :messages, dependent: :destroy
end
