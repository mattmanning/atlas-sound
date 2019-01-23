require "./app"
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

run Rack::URLMap.new('/' => App, '/sidekiq' => Sidekiq::Web)
