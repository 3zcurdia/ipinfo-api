class MemCache
  include Singleton
  attr_reader :values

  def initialize
    @values = {}
  end

  def fetch(key, &block)
    return values[key] if values.key?(key)

    new_val = block.call
    values[key] = new_val if new_val
  end
end

class Whereami
  def self.find(ip_address)
    self.new(ip_address).find
  end

  def initialize(ip_address, cache: MemCache.instance)
    @ip_address = ip_address.to_s
    @cache = cache
  end

  def find
    cache.fetch(ip_address) do
      response = Net::HTTP.get_response(uri)
      parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end
  end

  private

  attr_reader :ip_address, :cache

  def uri
    URI("https://ipinfo.io/#{ip_address}/geo")
  end

  def parse(body)
    json_response = JSON.parse(body)
    json_response.except('readme')
  rescue JSON::ParserError
    nil
  end
end

class App < Hanami::API
  get '/' do
    params.fetch(:ip, Rack::Request.new(env).ip)
    .then { |ip| Whereami.find(ip) }
    .then { |data| json(data) }
  end
end
