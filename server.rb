require 'sinatra'
require 'sinatra/namespace' # use namespaces in scope of the API
require 'sinatra/reloader' # make changes without a need to reboot
require 'sinatra/streaming'

require 'net/http'
require 'uri'
require 'thin'

require 'active_model'
require 'pry-byebug'

require 'logger'

set :server, :thin

# APIs
require './api/v1/poker_controller'
# HELPERS
Dir['./helpers/*.rb'].each {|file| require file }
# SERVICES
Dir['./services/*.rb'].each {|file| require file }
# MODELS
Dir['./models/*.rb'].each {|file| require file }
