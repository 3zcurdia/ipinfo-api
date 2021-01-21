# frozen_string_literal: true

class App < Hanami::API
  get '/' do
    request = Rack::Request.new(env)
    location = Geocoder.search(request.ip).first
    json(location&.data)
  end
end
