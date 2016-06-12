ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

# require 'rest-client'
# require 'pry'
# require 'yaml'
# require 'nokogiri'
# require 'term/ansicolor'

require_all 'lib'
require './app'

# Dir["./lib/concerns/*.rb"].each { |f| require f }
# Dir["./lib/cli/*.rb"].each { |f| require f }
# Dir["./lib/data_fetchers/*.rb"].each { |f| require f }
# Dir["./lib/models/*.rb"].each { |f| require f }