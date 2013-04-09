require 'bundler'
Bundler.require
require 'data_mapper'
require 'dm-core'
DataMapper.setup(:default, ENV['DATABASE_URL'] ||  "sqlite:db/pledger.db")

class Pledge
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :email, String, :required => true, :unique => true,
      :format   => :email_address,
      :messages => {
        :presence  => "We need your email address.",
        :is_unique => "We already have that email.",
        :format    => "Doesn't look like an email address to me ..."
      }
  property :amount_cents, Integer
  #property :exchange_rate, BigDecimal, :precision => 10, :scale => 
  #2, :default => 1 
end rescue nil

DataMapper.finalize

# issue CREATE statements (DROP table if it exists)
#DataMapper.auto_migrate!

# issue CREATE statements (Doesn't DROP tables)
DataMapper.auto_upgrade!

## INITIAL SETUP

enable :sessions

## APP

get '/' do
  @body_id = "Home"

  haml :index, :locals => {
    :c => Pledge.new,
    :action => '/create'
  }
end

get '/pledges' do
  haml :list, :locals => { :cs => Pledge.all }
end

get '/:id' do|id|
  @body_id = "List"
  
  c = Pledge.get(id)
  haml :show, :locals => { :c => c }
end

post '/create' do
  c = Pledge.new
  c.attributes = params
  c.save

  redirect("/#{c.id}")
end
