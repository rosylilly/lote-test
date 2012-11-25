require 'rubygems'
require 'bundler/setup'
Bundler.require

Lote::Application.initialize!(__FILE__)
run Lote::Application
