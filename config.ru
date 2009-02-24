require 'application' 

set :run, false
set :environment, ENV['APP_ENV'] || :production

run Sinatra::Application
