# http_server.rb
require 'socket'
require 'rack'
require 'rack/lobster'
require 'optparse'
require_relative 'request'
require_relative 'response'


server = TCPServer.new 5678
directory = nil
OptionParser.new do |parser|
  parser.banner = 'Enter example:  ruby http_server.rb -d public'
  parser.on('-d', '--directory=DIR') do |dir|
    directory = dir
  end
end.parse!
if directory.nil?
  puts 'Enter recourse directory!'
  return
end
while session = server.accept
  request = Request.new(session)
  puts request.request
  puts request.headers

  directory = '/' + directory + '/'

  response = Response.new
  response.handle_response(request, directory)
  response.send(session)

  session.close
end