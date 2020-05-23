class HttpServer
  def initialize(port:, directory:)
    @server = TCPServer.new port
    @directory = directory
    @database = {}
  end

  def run
    loop do
      session = @server.accept
      request = Request.new(session)
      puts("-------------------")
      puts request.request
      puts request.headers

      @directory = '/' + @directory + '/'

      response = Response.new(session)
      response.handle_response(request, @directory, @database)
      session.close
    end
  end
end