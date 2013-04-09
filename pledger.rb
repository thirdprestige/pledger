require 'bundler'
Bundler.require
require 'data_mapper'
require 'dm-core'
DataMapper.setup(:default, ENV['DATABASE_URL'] ||  "sqlite:db/pledger.db")

class Pledge
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :email, String
  property :amount_cents, Integer
end rescue nil

DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

## INITIAL SETUP

enable :sessions

## APP

get '/' do
  @body_id = "pledger.account_31"

  haml :index, :locals => {
    :c => Pledge.new,
    :action => '/create'
  }
end

get '/pledges' do
  haml :list, :locals => { :cs => Pledge.all }
end

get '/:id' do|id|
  @body_id = "thanks"
  
  c = Pledge.get(id)
  haml :show, :locals => { :c => c }
end