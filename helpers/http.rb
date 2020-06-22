# Http method alias functions
require 'json'


def get(query)
  HTTParty.get(query, { :headers => {'Authorization' => $api_token, 'Accept' => 'application/json', 'Content-Type' => 'application/json'}})
end

def post(query, data)
  puts data.to_json
  HTTParty.post(query, options = {:headers => {'Authorization' => $api_token, 'Accept' => 'application/json', 'Content-Type' => 'application/json'}, body: data})
end