require 'sinatra'
require 'sinatra/namespace' # use namespaces in scope of the API
require 'sinatra/reloader' # make changes without a need to reboot

# APIs
require './api/v1/routes'

# MODELS
Dir['./models/*.rb'].each {|file| require file }
