require 'sinatra'
require 'sinatra/namespace' # use namespaces in scope of the API
require 'sinatra/reloader' # make changes without a need to reboot
require 'sinatra/streaming'

require 'net/http'
require 'uri'
require 'thin'

require 'pry-byebug'

set :server, :thin

# APIs
require './api/v1/routes'

# MODELS
Dir['./models/*.rb'].each {|file| require file }
