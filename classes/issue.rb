require_relative '../helpers/http'
require 'json'

class Issue

  def show(opts = {})
    @response = get($api_base_url + "issues/#{opts[:id]}?fields=idReadable,created,updated,resolved,numberInProject,project(name),summary,description,comments(created,text,author(fullName)),tags")
    @results = JSON.parse(@response.body)
    puts "IssueID: #{@results['idReadable']}"
    puts "Summary: #{@results['summary']}"
    puts "ProjectName: #{@results['project']['name']}"
    puts "--------------------------------------------------------------------------------------------------------------------------------------------"
    puts "Description:\n\n#{@results['description']}"
    puts "--------------------------------------------------------------------------------------------------------------------------------------------"
    puts "Comments:\n\n"
    @results['comments'].map {|comment| puts "#{comment['author']['fullName']} => #{comment['text']}./commented at - #{@results['created']}/\n\n"}
    puts "--------------------------------------------------------------------------------------------------------------------------------------------"
    puts "Resolved?: #{@results['resolved'] ? @results['resolved'] : 'false'}"
    puts "Tags: #{@results['tags']}"
    puts "Created: #{@results['created']}"
    puts "Updated: #{@results['updated']}"
  end
end