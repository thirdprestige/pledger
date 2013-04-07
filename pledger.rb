require 'bundler'
Bundler.require


## DATABASE INITIALIZATION

DB = Sequel.connect(ENV['DATABASE_URL'])

DB.create_table :pledges do
  primary_key :id # user ID
  String :email
  Integer :amount_cents
end rescue nil


## INITIAL SETUP

enable :sessions


## APP

get '/' do
  session[:user_id] ||= DB[:pledges].insert()

  erb :index
end

get '/pledges' do
  content_type :json

  { amount_cents: DB[:pledges].sum(:amount_cents) }.to_json
end

get '/thanks' do
  erb :thanks
end

# Update a pledge,
# based on the session ID
#
# POST params:
# - amount_cents
# - email
post '/pledges' do
  DB[:pledges].where(id: session[:user_id]).update(
    amount_cents: params[:amount_cents],
    email: params[:email]
  )

  { status: :ok }.to_json
end
