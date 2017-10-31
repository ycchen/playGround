# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

> rails g scaffold Author name:string

> rails g scaffold Book author:references published_at:datetime


> rails g scaffold Supplier name:string

> rails g scaffold Account supplier:references account_number:string

> rails g migration CreateAppointments

class Appointment < ApplicationRecord
	belongs_to :physician
	belongs_to :patient
end

class Physician < ApplicationRecord
	has_many :appointments
	has_many :patients, through: :appointments
end

class Patient < ApplicationRecord
	has_many :appointments
	has_many :physicians, through: :appointments
end

class Document < ApplicationRecord
	has_many :sections
	has_many :paragraphs, thought: :sections
end

class Section < ApplicationRecord
	belongs_to :document
	has_many :parapgrahs
end

class Paragraph < ApplicationRecord
	belongs_to :section
end

### Polymprohic Associations

> rails g scaffold Employee name:string

> rails g scaffold Product name:string

> rails g model Picture name:string imageable:references{polymorphic}

> rails g migration AddManagerToEmployee manager_id:integer

### Self Joins

Employee belongs_to :manager 
Employee has_many :subordinates


### Single Table Inheritance

> rails g model vehicle type:string color:string price:decimal{10,2}

#### Generate Car model

> rails g model car --parent=Vehicle

-- This will created a model called "Car" and it is inheritance from Vehicle model

> rails g model bicycle --parent=Vehicle

> rails g model motocycle --parent=Vehicle

## Active Record Query Interface

> rails g model 

#### Find or Build a new object 

-- find_or_create_by

-- find_or_create_by!

-- find_or_initialize_by (this will call .new method instead of .create)

-- find_by_sql("SELECT * from clients WHERE 0=1")

-- Client.connection.select_all("SELECT * from clients WHERE 0=1")

-- Pluck

Client.where(active: true).pluck(:id)
# SELECT id FROM clients WHERE active = 1
# => [1, 2, 3]
 
Client.distinct.pluck(:role)
# SELECT DISTINCT role FROM clients
# => ['admin', 'member', 'guest']
 
Client.pluck(:id, :name)
# SELECT clients.id, clients.name FROM clients
# => [[1, 'David'], [2, 'Jeremy'], [3, 'Jose']]

Client.select(:id).map { |c| c.id }
# or
Client.select(:id).map(&:id)
# or
Client.select(:id, :name).map { |c| [c.id, c.name] }

>rails g model mountain name

>rails g model climber name

> rails g migration CreateClimbersMountains mountain:references climber:references

>rails g model magazine name

>rails g model reader name

>rails g model subscription type length:integer magazine:references reader:references

#### ActionCable

> rails g channel notifications

#### Create background job

> rails g job NotificationBroadcast

#### open 2 different broswers

#### first broswer go to http://localhost:3000/messages


#### second broswer go to http://localhost:3000  # to view live notification

#### http://myprogrammingblog.com/2016/08/22/deploy-actioncable-to-heroku-part4/

#### https://github.com/myprogrammingblog/notificator-rails5-example


### Adding Active Job with resque

> rails g migration CreateSnippet name:string language:string plain_code:text highlighted_code:text

-- config/application.rb
config.active_job.queue_adapter = :resque

--lib/tasks/resque.rake
require 'resque/tasks'
task 'resque:setup' => :environment

#### Create Snippet Controller/Model and View

#### post code to http://pygments.simplabs.com/

require 'net/http'
require 'uri'

lang = 'ruby'
code = 'class Test; end'

response = Net::HTTP.post_form(URI.parse('http://pygments.simplabs.com/'), { 'lang' => lang, 'code' => code })
puts response.body

#### Generate ActiveJob with resque 

* Example ActiveJob with RSpec Tests
https://gist.github.com/ChuckJHardy/10f54fc567ba3bd4d6f1

*	ActiveJob with Resque
https://github.com/resque/resque/wiki/ActiveJob


Rails 4.2 introduced ActiveJob, a standard interface for job runners. Here is how to use Resque with ActiveJob.

* Make sure you have Redis installed and `gem 'resque'` is in your Gemfile

* Set Resque as queue adapter in `config/application.rb`.

`config.active_job.queue_adapter = :resque`

* In your `Rakefile` add the following to access resque rake tasks

`require 'resque/tasks'`

If you're running Rails 5.x, also add

`task 'resque:setup' => :environment`

* Generate your job

`rails g job Cleanup`

* This will generate new job at `app/jobs` folder:
```ruby
class CleanupJob < ActiveJob::Base
  queue_as :default

  def perform(arg1, arg2)
    #your long running code here
  end
end
```

* Run this job anywhere at your code like this:

```ruby
#just run
CleanupJob.perform_later(arg1, arg2)

#or set the queue name
CleanupJob.set(queue: user.name).perform_later(arg1, arg2)

#or set the delay
CleanupJob.set(wait: 1.week).perform_later(arg1, arg2)

#or run immediately
CleanupJob.perform_now(arg1, arg2)

```

* Run Redis server
```sh
redis-server /usr/local/etc/redis.conf
```

* Run the following in console (otherwise your workers will not start (just pending))

```sh
QUEUE=* rake resque:work
```

* Additionally, you can mount web-version of Resque to your project, add this to your `routes.rb`

```ruby
require 'resque/server'
mount Resque::Server, at: '/jobs'

#or if you would like to protect this with Devise
devise_for :users

authenticate :user do
  mount Resque::Server, at: '/jobs'
end
```



> rails g job SnippetHighlighter

--jobs/snippet_highligher_job.rb
  def perform(*args)
    # Do something later
    uri = URI.parse('http://pygments.simplabs.com/')
    snippet = Snippet.find(args[0])
		request = Net::HTTP.post_form(uri, {'lang' => snippet.language, 'code' => snippet.plain_code})
		snippet.update_attribute(:highlighted_code, 'foobar')
  end

-- conrollers/snippets_controller.rb

def create
		@snippet = Snippet.new(snippet_params)
		if @snippet.save
--		SnippetHighlighterJob.perform_later(@snippet.id)
			logger.debug "SET SnippetHighlighterJob(#{@snippet.id}) in to the queue!!!!!!"
			redirect_to @snippet, :notice => "Successfully created snippet"
		else
			render :new
		end
	end

#### once snippet is created and SnippetHighlighterJob.perform_later(@snippet.id) has been sent to a queue.

### it will run all of job in the queue, MAKE SURE THIS COMMAND NEED TO RUN BEFORE THE JOB GET SEND TO A QUEUE
$ QUEUE=* rake resque:work 

#### you can run following command to set an Active Job into queue

> rails runner "SnippetHighlighterJob.perform_later(10)" && tail -n 1 log/development.log


#### you can tail or grep the log to see the Active Job

> grep --color "\[\SnippetHighlighterJob\]" -A 3  log/development.log


### Action Mailer

> rails g mailer UserMailer

* create welcome_email.html.erb and welcome_email.text.erb

* calling the Mailer

> rails g scaffold user name email login



#### Caching:  page, action and fragment caching. 

* By default Rails provides fragment caching. in order to use page and action caching you will need to add 
'actionpack-page_caching' and 'acitonpack-action_caching' to your Gemfile

* By default, caching is only enabled in your production environment. To play around with caching locally you'll want to enable caching in your local environment by setting 'config.action_controller.perform_caching' to true in the relevant config/environments/*.rb file

* Page caching has been removed from Rails 4.

* Action caching has been removed from Rails 4.

* Action Caching: Page Caching cannot be used for actions that have before filters. for example, pages that require authentication.  This 
is where Action Caching comes in.  Action Caching works like Page Caching except the incoming web request hits the Rails stack so that before filters can be run on it before the cache is served.  This allows authentication and other restrictions to be run while still serving the result of the output from a cached copy.

* Fragment Caching: For example, if you wanted to cache each production on a page. you could use this code:

```ruby
	<% @products.each do |product| %>
		<% cache product do %>
			<%= render product %>
		<% end %>
	<% end %>
```

when your application receiveds its first request to this page, Rails will write a new cache entry with a unique key. A key looks something like this views/products/1-201505056193031061005000/bea67108094918eeba42cd4a6e786901

* The number in the middle is the product_id followed by the temestamp value in teh updated_at attribute of the product record. Rails uses the timestamp value to make sure it is not serving stale data.  If the value of updated_at has changed, a new key will be generated. Then Rails will write a new cache to that key, and the old cache written to the old key will never be used again. This is called key-based expiration.


* Cache fragments will also be expired when the view fragment changes (the HTML in the view changes). 

* Cache stroes like Memcached will automatically delete old cache files.

* Cache a fragment under certain conditions. you can use cache_if or cache_unless

```ruby
<% cache_if admin?, product do %>
	<%= render product %>
<% end%>
```

*Collection caching

```ruby
	<%= render partial: 'products/product', collection: @products, cached: true %>
```


#### Russian Doll Caching
* You may want to nest cached fragments inside other cached fragments. This is called Russian doll caching.

* The advantage of Russian doll caching is that if a single product is updated, all the other inner fragments can be resued when regenerating the outer fragment.


```ruby
	<% cache product do %>
	<%= render product.games %>
	<% end %>


	<% cache game do %>
		<%= render game %>
	<% end%>
```
* if any attribute of game is changed, the updated_at value will be set to the current time, thereby expiring the cache.  However, because updated_at will not be changed for the product object, that cache will not be expired and your app will serve stale data. To fix this, we tie the models together with the touch method:

```ruby
class Product < ApplicationRecord
	has_many :games
end

class Game < ApplicationRecord
	belongs_to :production, touch: true
end
```
with touch set to true, any action which changes updated_at for a game record will also change it for the associated product, thereby expiring the cache.


```ruby
class Product < ApplicationRecord
	def competing_price
		Rails.cache.fetch("#{cache_key}/competing_price", expires_in: 12.hours) do
			Competitor::API.find_price(id)
		end
	end
end
```