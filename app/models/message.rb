class Message < ApplicationRecord
	after_create_commit {reload_demo}
	after_create_commit {notify}

	private
	def notify
		Notification.create(event: "New Notification (#{self.body})")
	end

	def reload_demo(max=20)
	end

end
