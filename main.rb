require_relative 'config.local'
require 'httparty'


class RequestHandler 

    attr_accessor :headers, :base_url
  
    def initialize(base_url, api_token)
      @headers = { 'Authorization' => api_token, 'Accept' => 'application/json', 'Content-Type' => 'application/json'}
      @base_url = base_url
      @base_request = HTTParty.get(@base_url, { :headers =>  @headers })
    end

end


request_handler = RequestHandler.new($api_base_url, $api_token)





