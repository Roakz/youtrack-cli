require_relative 'config.local'
require 'httparty'
require 'json'


def help_docs 
  puts "Youtrack-CLI Instructions for use\n  Command structure: youtrack <ENTITY i.e Issue or Project>  <METHOD/CRUD action>"
end

def get(query)
  HTTParty.get(query, { :headers => {'Authorization' => $api_token, 'Accept' => 'application/json', 'Content-Type' => 'application/json'}})
end

class Project 

  attr_reader :index

  def index
    @response = get($api_base_url + "admin/projects?fields=id,name")
    if @response.code == 200
      @results = JSON.parse(@response.body)
      @results.each do |project|
        puts "Project: #{project['name']}, ProjectId: #{project['id']}"
      end
    else
      @error = JSON.parse(@response.body)
      puts "Error: #{@error['error']}"
    end
  end

  def show(opts = {})
    @response = get($api_base_url + "admin/projects/#{opts[:id]}?fields=name,shortName,description,createdBy,team(name,usersCount)")
    @results = JSON.parse(@response.body)
    puts "Project name: #{@results['name']}" 
    puts "ShortName: #{@results['shortName']}"
    puts "Created By: #{@results['createdBy']}" unless !@results['createdBy'] 
    puts "Team: #{@results['team']['name']} with user count of #{@results['team']['usersCount']}" unless !@results['team']
    puts "Description: #{@results['description']}"
  end

  def issues(opts = {})
    if opts[:count]
      @response = get($api_base_url + "admin/projects/#{opts[:id]}?fields=issues(id)")
      puts @response['issues'].length
      puts "wowza! you have alot of issues!" unless @response['issues'].length < 100
    else
      @response = get($api_base_url + "admin/projects/#{opts[:id]}?fields=name,issues(id,name,summary)")
      if @response.code == 200
        @results = JSON.parse(@response.body)
        puts "#{@response['name']} issues: \n"
        @results['issues'].each do |issue|
          puts ""
          puts "Issue id: " + issue['id']
          puts "Summary: " + issue['summary']
          puts "_____________________________________________________________________________________________________________"
        end
      else
        @error = JSON.parse(@response.body)
        puts "Error: #{@error['error']}"
      end
    end
  end
end

if ARGV.length > 0
  if !%w(show update delete create issues).include?(ARGV[1])
    method_to_call = ARGV[1]
    class_to_call = Object.const_get(ARGV[0]).new()
    class_to_call.public_send(method_to_call) if class_to_call.respond_to? method_to_call
  else
    method_to_call = ARGV[1]
    class_to_call = Object.const_get(ARGV[0]).new()
    opts = ARGV.length == 4 ? { :id => ARGV[2], :count => "I exist! give the man (or women) a count !"} : {:id => ARGV[2]}
    class_to_call.public_send(method_to_call, opts ) if class_to_call.respond_to? method_to_call
  end
else   
  help_docs()  
end