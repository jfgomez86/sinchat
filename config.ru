require 'main' 

set_option :run, false
set_option :env, ENV['APP_ENV'] || :production

run Sinatra::Application
