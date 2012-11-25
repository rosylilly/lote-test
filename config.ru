require 'rubygems'
require 'bundler/setup'
Bundler.require

Lote::Application.initialize!(__FILE__)

Lote::Application.routes! do
  get '/', 'home#index'

  get '/not_found', 'home#not_found'
end

run Lote::Application
