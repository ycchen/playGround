class MessagingController < ApplicationController
	include ActionController::Live

	def send_message
		response.headers['Content-Type']= 'text/event-stream'
		
		10.times{ |i|
			response.stream.write "#{i} This is a test Messagen #{params[:message]} #{Time.now}\n"
			sleep 1
		}
	ensure
		response.stream.close
	end
end
