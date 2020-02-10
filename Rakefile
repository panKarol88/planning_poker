require 'dotenv'
Dotenv.load

require 'logger'
logger = Logger.new STDOUT
logger.level = Logger::INFO


desc 'setup task'
task :setup do
  logger.info ' --- PLANNING POKER --- SETUP'
  system 'bundle install'
end

# example: rake server[development, 4567]
# zsh example: rake server\[development,4567\]
desc 'run server'
task :server, [:environment, :port] do |t, args|
  logger.info ' --- PLANNING POKER --- SERVER STARTING NOW ...'

  environment = args[:environment] || ENV['ENVIRONMENT'] || 'development'
  port = args[:port] || ENV['PORT'] || '4567'

  logger.info " ENVIRONMENT: #{environment}, LISTENNING ON PORT: #{port}"

  exec "thin -R config.ru start -e #{environment} -p #{port}"
end

desc 'client console'
task :start do
  logger.info ' --- PLANNING POKER --- STARTS'
  system 'irb -r ./client_script.rb'
end
