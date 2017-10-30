class NewsletterSubscriberJob < ApplicationJob
  queue_as :subscriber

  def perform(*args)
    # Do something later
    sleep 5
    puts "Do send newsletter subscription confirmation later"
  end
end
