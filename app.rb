class App < Hanami::API
  get '/' do
    request_ip = params[:ip] || Rack::Request.new(env).ip
    location = Geocoder.search(request_ip).first
    json(location&.data)
  end
end
