# Request dependencies
require 'taric'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

# Config API Key for Taric
Taric.configure! do |config|
  config.api_key = 'RGAPI-0020053d-293a-4240-be86-d688a3dbdcd6'
  config.adapter = :typhoeus # default is Faraday.default_adapter
end

# A Summoner has reconnected
@taric = Taric.client(region: :lan) # Info about regions at Taric Github <3
