require_relative 'config.local'
require 'httparty'
require 'json'



def help_docs 
  puts "Youtrack-CLI Instructions for use\n
  Command structure: youtrack <ENTITY i.e Issue or Project>  <METHOD/CRUD action>"
end


class Project 

  attr_reader :index

  def index
    response = HTTParty.get($api_base_url + "admin/projects?fields=id,name", { :headers =>  { 'Authorization' => $api_token, 'Accept' => 'application/json', 'Content-Type' => 'application/json'}})
    results = JSON.parse(response.body)
    results.each do |project|
      puts "Project: #{project['name']}, ProjectId: #{project['id']}"
    end
  end
end

if ARGV.length > 0
  method_to_call = ARGV[1]
  class_to_call = Object.const_get(ARGV[0]).new()
  class_to_call.public_send(method_to_call) if class_to_call.respond_to? method_to_call
else   
  help_docs()  
end