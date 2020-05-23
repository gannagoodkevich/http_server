require 'logging'

class HttpServer
  def initialize(port:, directory:, log_file:)
    @server = TCPServer.new port
    @directory = directory
    logger = Logging.logger['logger']
    logger.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file(log_file)
    )
    logger.level = :info

    @logger = logger
    @database = {}
  end

  def run
    loop do
      session = @server.accept
      request = Request.new(session)
      @logger.info '-----REQUEST-TO-SERVER-----'
      @logger.info request.request
      @logger.info request.headers

      @directory = '/' + @directory + '/'

      response = Response.new
      response.handle_response(request, @directory, @database)
      @logger.info '-----RESPONSE-FROM-SERVER-----'
      @logger.info response.response
      response.send(session)
      session.close
    end
  end
end