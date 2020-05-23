require 'socket'
require 'optparse'
require_relative 'request'
require_relative 'response'
require_relative 'http_server'



directory = 'public'
port = 8080
OptionParser.new do |parser|
  parser.banner = 'Enter example:  ruby run.rb -d public'
  parser.on('-d', '--directory=DIR') do |dir|
    directory = dir
  end
  parser.on('-p', '--port=P') do |p|
    port = p
  end
end.parse!
#if directory.nil?
# puts 'Enter recourse directory!'
# return
#end
#if port.nil?
# puts 'Enter recourse port!'
# return
#end

server = HttpServer.new(port: port, directory: directory)
server.run
