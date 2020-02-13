require 'sinatra'
require 'sinatra/namespace' # use namespaces in scope of the API
require 'sinatra/reloader' # make changes without a need to reboot
require 'sinatra/streaming'

require 'net/http'
require 'uri'
require 'thin'
require 'redis'
require 'redlock'

require 'active_model'
require 'pry-byebug'

require 'logger'

require 'dotenv'
Dotenv.load

set :server, :thin
set :server_settings, :timeout => 600

# INITIALIZERS
require './config/initializers'
# APIs
require './api/v1/poker_controller'
# HELPERS
Dir['./helpers/*.rb'].each {|file| require file }
# SERVICES
Dir['./services/server_services/*.rb'].each {|file| require file }
# MODELS
Dir['./models/*.rb'].each {|file| require file }
