require_relative 'config.local'
require_relative 'help'
require_relative 'classes/project'
require_relative 'classes/issue'

require 'httparty'


def main
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
end

main