class Response
  STATUS_CODE_OK = 200
  STATUS_CODE_NOT_FOUND = 404
  STATUS_CODE_NOT_ALLOWED = 405

  def initialize
    @allowed_methods = %w[GET POST OPTIONS]
  end

  def handle_response(request, directory)
    handle_data(request, directory)
    @response =
      "HTTP/1.1 #{@code}\r\n" \
      "Content-Length: #{@data.size}\r\n" \
      "\r\n" \
      "#{@data}\r\n"
  end

  def send(session)
    session.write(@response)
  end

  private

  def handle_data(request, directory)
    @data = ''
    unless request.recourse.empty? || request.recourse.eql?('favicon.ico')
      path = File.dirname(__FILE__) + directory + request.recourse
      handle_status_code_by_methods(request)
      handle_status_code_by_recourse(path)
      @data = File.binread(path) if recourse_exists?(path)
    end
  end

  def recourse_exists?(path)
    File.exists?(path)
  end

  def handle_status_code_by_recourse(path)
    if @code.nil?
      @code = if recourse_exists?(path)
                STATUS_CODE_OK
              else
                STATUS_CODE_NOT_FOUND
              end
    end
    puts @code
  end

  def handle_status_code_by_methods(request)
    unless @allowed_methods.include?(request.http_method)
      @code = STATUS_CODE_NOT_ALLOWED
    end
  end
end