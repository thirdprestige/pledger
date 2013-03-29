require 'bundler'
Bundler.require

Sequel.connect(ENV['DATABASE_URL'])

enable :sessions

get '/' do
  session[:user_id] ||= 'what'
end

post '/pledges' do
  DB[:pledges].where(id: session[:user_id]).update(
    amount: params[:amount],
    email: params[:email]
  )

  json({ status: :ok })
end
