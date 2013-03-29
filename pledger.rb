require 'bundler'
Bundler.require


## DATABASE INITIALIZATION

Sequel.connect(ENV['DATABASE_URL'])

DB.create_table :pledges do
  primary_key :id # user ID
  String :email
  Integer :amount_cents
end


## INITIAL SETUP

enable :sessions


## APP

get '/' do
  session[:user_id] ||= DB[:pledges].insert()
end

post '/pledges' do
  DB[:pledges].where(id: session[:user_id]).update(
    amount_cents: params[:amount_cents],
    email: params[:email]
  )

  json({ status: :ok })
end
