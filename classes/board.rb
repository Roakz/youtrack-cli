require_relative '../helpers/http'
require 'json'

class Board

  def index
    @response = get($api_base_url + "agiles?fields=name,id,status(valid)")
    @results = JSON.parse(@response.body)
    @results.map {|result| puts "- #{result['name']}, Status: #{result['status']['valid'] ? "active" : "non-active"}, ID: #{result['id']}"}
  end
end