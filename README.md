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

