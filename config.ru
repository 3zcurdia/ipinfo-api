require 'bundler/setup'
require 'hanami/api'
require 'singleton'
require 'net/http'
require 'uri'
require './app'

run App.new
