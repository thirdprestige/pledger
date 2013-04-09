require './pledger'

#run Sinatra::Application
web: bundle exec unicorn -p $PORT -c ./unicorn