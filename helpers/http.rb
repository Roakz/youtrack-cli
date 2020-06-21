# Http method alias functions
def get(query)
  HTTParty.get(query, { :headers => {'Authorization' => $api_token, 'Accept' => 'application/json', 'Content-Type' => 'application/json'}})
end