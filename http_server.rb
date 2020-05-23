# http_server.rb
require 'socket'
require 'rack'
require 'rack/lobster'

server = TCPServer.new 5678

while session = server.accept
  request = session.gets
  puts request
  puts session.readpartial(2048)

  session.close
end