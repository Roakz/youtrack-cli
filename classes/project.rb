require_relative '../helpers/http'
require 'json'

class Project 

  def index
    @response = get($api_base_url + "admin/projects?fields=id,name,shortName")
    if @response.code == 200
      @results = JSON.parse(@response.body)
      @results.each do |project|
        puts "Project: #{project['name']}, Project short: #{project['shortName']}, ProjectId: #{project['id']}}"
      end
    else
      @error = JSON.parse(@response.body)
      puts "Error: #{@error['error']}"
    end
  end

  def show(opts = {})
    @response = get($api_base_url + "admin/projects/#{opts[:id]}?fields=name,shortName,description,createdBy,team(name,usersCount)")
    @results = JSON.parse(@response.body)
    puts "ProjectId:  #{@results['shortName']}"
    puts "Project name: #{@results['name']}" 
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
      @response = get($api_base_url + "admin/projects/#{opts[:id]}?fields=name,issues(name,summary,idReadable)")
      if @response.code == 200
        @results = JSON.parse(@response.body)
        puts "#{@response['name']} issues: \n"
        @results['issues'].each do |issue|
          puts ""
          puts "Id: " + issue['idReadable'] 
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