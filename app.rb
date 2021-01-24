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

class IpInfo
  def self.geo(ip_address)
    self.new(ip_address).geo
  end

  def initialize(ip_address, cache: MemCache.instance)
    @ip_address = ip_address.to_s
    @cache = cache
  end

  def geo
    cache.fetch(ip_address) do
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body) rescue nil
      end
    end
  end

  private

  attr_reader :ip_address, :cache

  def uri
    URI("https://ipinfo.io/#{ip_address}/geo")
  end
end

class App < Hanami::API
  get '/' do
    params.fetch(:ip, Rack::Request.new(env).ip)
    .then { |ip| IpInfo.geo(ip) }
    .then { |location| json(location) }
  end
end
