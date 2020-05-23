class Request
  attr_reader :request, :headers

  ROOT = '/index.html'.freeze
  
  def initialize(session)
    @session = session
    gets = session.gets
    @request = gets.split(' ') if gets
    @headers = session.readpartial(2048)
  end

  def recourse
    if @request[1].eql?('/')
      ROOT
    else
      @request[1][1..-1]
    end
  end

  def http_method
    @request.first
  end
end