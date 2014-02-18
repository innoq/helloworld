require 'net/http'

class ForeignLinks

  attr_reader :base_uri

  def initialize(base_uri, local_resources)
    @base_uri = URI.parse(base_uri)
    @resources = {}
    reload(local_resources)
  end

  def reload(local_resources = nil)
    Net::HTTP.start(base_uri.host, base_uri.port) do |http|
      req = if local_resources.is_a?(Hash)
        r = Net::HTTP::Put.new(base_uri.request_uri)
        r.body = JSON.generate("resources" => local_resources.each_with_object({}) { |(k, v), memo|
            k = "http://helloworld.innoq.com/#{k}" unless k.to_s.include?("/")
            memo[k] = v
          })
        r["Content-Type"] = "application/json"
        r
      else
        Net::HTTP::Get.new(base_uri.request_uri)
      end
      req['Accept'] = "application/json-home"
      res = http.request(req)
      if res.is_a?(Net::HTTPSuccess)
        @resources = JSON.parse(res.body)["resources"] || {}
        Rails.logger.info("Found ForeignLinks: #{@resources.keys.inspect}")
      else
        raise RuntimeError.new("HTTP error: '#{res.code} #{res.message}'")
      end
    end
  rescue Net::HTTPExceptions, Errno::ECONNREFUSED, RuntimeError => e
    if Rails.env.development?
      puts e
      Rails.logger.error e
      @resources = {}
    else
      raise e
    end
  end

  def uri(resource, params = {})
    ForeignLinks.uri(@resources, resource, params)
  end

  def self.uri(resources, resource, params = {})
    params = HashWithIndifferentAccess.new(params)
    data = resources[resource.to_s]
    if data.is_a?(Hash) && data["href"].is_a?(String)
      data["href"].to_s
    elsif data.is_a?(Hash) && data["href-template"].is_a?(String) && data["href-vars"].is_a?(Hash)
      uri = data["href-template"].to_s
      unknown_keys = (params.keys.map(&:to_s) - data["href-vars"].keys)
      Rails.logger.warn("Unknown keys #{unknown_keys.inspect} in ForeignLinks#uri call") if unknown_keys.any?
      data["href-vars"].each do |key, type_uri|
        Rails.logger.warn("Missing key '#{key}' in ForeignLinks#uri call") unless params[key]
        uri.gsub!("{#{key}}", params[key].to_s)
      end
      uri
    else
      Rails.logger.warn("Couldn't find valid JSON home data for '#{resource}'")
      nil
    end
  end

end