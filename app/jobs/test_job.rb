class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Rails.logger.debug "#{self.class.name}: I'm performing my job with arguments: #{args.inspect}"

    Message.all.inspect
  end
end
