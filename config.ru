# frozen_string_literal: true

require 'bundler/setup'
require 'hanami/api'
require 'geocoder'
require 'json'
require './app'

run App.new
