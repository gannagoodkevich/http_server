require 'socket'
require 'optparse'
require_relative 'request'
require_relative 'response'
require_relative 'http_server'



directory = ''
port = ''
log_file = ''
OptionParser.new do |parser|
  parser.banner = 'Enter example:  ruby run.rb -d public'
  parser.on('-d', '--directory=DIR') do |dir|
    directory = dir
  end
  parser.on('-p', '--port=P') do |p|
    port = p
  end
  parser.on('-l', '--log-file=log') do |log|
    log_file = log
  end
end.parse!
if directory.empty?
  puts 'Enter recourse directory!'
  return
end

port = '8080' if port.empty?
log_file = 'default.log' if log_file.empty?

server = HttpServer.new(port: port, directory: directory, log_file: log_file)
server.run
