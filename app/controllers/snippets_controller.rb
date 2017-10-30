class SnippetsController < ApplicationController
	before_action :set_snippet, only: [:show, :edit, :update, :destroy]

	def new
		@snippet = Snippet.new
	end

	def create
		@snippet = Snippet.new(snippet_params)
		if @snippet.save

			# uri = URI.parse('http://pygments.simplabs.com/')
			# request = Net::HTTP.post_form(uri, {'lang' => @snippet.language, 'code' => @snippet.plain_code})
			# @snippet.update_attribute(:highlighted_code, request.body)
			SnippetHighlighterJob.perform_later(@snippet.id)
			logger.debug "==============================="
			logger.debug "SET SnippetHighlighterJob(#{@snippet.id}) in to the queue!!!!!!"
			redirect_to @snippet, :notice => "Successfully created snippet"
		else
			render :new
		end
	end

	def show
	end

	private

	def set_snippet
		@snippet = Snippet.find(params[:id])
	end

	def snippet_params
		params.require(:snippet).permit(:name, :language, :plain_code, :highlighted_code)
	end

end