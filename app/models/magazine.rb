class Magazine < ApplicationRecord
	has_many :subscriptions
	has_many :readers, through: :subscriptions
end
