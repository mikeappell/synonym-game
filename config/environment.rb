require 'bundler/setup'
Bundler.require

require 'rest-client'
require 'pry'
require 'yaml'
require 'nokogiri'
require 'term/ansicolor'

Dir["./lib/concerns/*.rb"].each { |f| require f }
Dir["./lib/cli/*.rb"].each { |f| require f }
Dir["./lib/data_fetchers/*.rb"].each { |f| require f }
Dir["./lib/models/*.rb"].each { |f| require f }