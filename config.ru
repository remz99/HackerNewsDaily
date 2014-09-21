# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

#
# Sidekiq web panel
#
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require 'sidekiq/web'
require 'sidetiq/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == Rails.application.secrets[:sidekiq][:username] &&
    password == Rails.application.secrets[:sidekiq][:password]
  end

  run Sidekiq::Web
end