class SnippetHighlighterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later

    logger.debug "#{self.class.name}: ----- I'm performing my job with arguments: #{args.inspect}"
    logger.debug "=========#{args[0]}"
    uri = URI.parse('http://pygments.simplabs.com/')
    logger.debug "URI: #{uri}"
    snippet = Snippet.find(args[0])
		request = Net::HTTP.post_form(uri, {'lang' => snippet.language, 'code' => snippet.plain_code})
		snippet.update_attribute(:highlighted_code, "FOOBAR This is updated at #{Time.now}")
			
  end
end
