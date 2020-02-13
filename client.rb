require 'net/http'
require 'uri'

require 'active_model'
require 'pry-byebug'

require 'logger'

require 'dotenv'
Dotenv.load

# HELPERS
Dir['./helpers/*.rb'].each {|file| require file }
# SERVICES
Dir['./services/*.rb'].each {|file| require file }
# MODELS
Dir['./models/*.rb'].each {|file| require file }
