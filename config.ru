# frozen_string_literal: true

require 'bundler/setup'
require 'hanami/api'
require 'rack/cache'
require 'geocoder'
require './app'

use Rack::Cache
run App.new
