class HttpServer
  def initialize(port: 8080, directory:)
    @server = TCPServer.new port
    @directory = directory
    @database = {}
  end

  def run
    while session = @server.accept
      request = Request.new(session)
      puts request.request
      puts request.headers

      @directory = '/' + @directory + '/'

      response = Response.new
      response.handle_response(request, @directory, @database)
      response.send(session)
      puts "I'm here"
      puts session.close.inspect
    end
  end
end