require 'rubygems'
require 'bundler'

Bundler.require

require './lib/txt_server.rb'

run TxtServer::App
