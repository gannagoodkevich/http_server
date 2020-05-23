class Response
  attr_reader :response
  STATUS_CODE_OK = 200
  STATUS_CODE_CREATED = 201
  STATUS_CODE_NOT_FOUND = 404
  STATUS_CODE_NOT_ALLOWED = 405
  STATUS_CODE_NOT_IMPLEMENTED = 501

  def initialize
    @allowed_methods = %w[GET POST OPTIONS]
  end

  def handle_response(request, directory, database)
    if handle_status_code_by_methods(request)
      public_send('handle_get_response', request, directory)
    else
      if request.http_method.downcase.eql?('post')
        public_send("handle_#{request.http_method.downcase}_response", request, database)
      else
        public_send("handle_#{request.http_method.downcase}_response", request, directory)
      end
    end
  end

  def send(session)
    session.write(@response)
  end

  def handle_get_response(request, directory)
    handle_data(request, directory)
    @response = "HTTP/1.1 #{@code}\r\n" \
                "Content-Length: #{@data.size}\r\n" \
                "\r\n" \
                "#{@data}\r\n"
  end

  def handle_post_response(request, database)
    handle_posted_data(request, database)
    @response = "HTTP/1.1 #{@code}\r\n" \
                "\r\n" \
                "#{database}\r\n"
  end

  def handle_options_response(request, directory)
    @code = 200
    @response = "HTTP/1.1 #{@code}\r\n" \
                "Allow: #{@allowed_methods}\r\n" \
                "\r\n" \
                "#{@allowed_methods}\r\n"
  end

  private

  def handle_data(request, directory)
    @data = ''
    unless request.recourse.empty? || request.recourse.eql?('favicon.ico')
      path = File.dirname(__FILE__) + directory + request.recourse
      handle_status_code_by_recourse(path)
      @data = File.binread(path) if recourse_exists?(path)
    end
  end

  def handle_posted_data(request, database)
    posted_data = request.recourse.split('=')
    if database.keys.include? posted_data.first[1..-1]
      @code = STATUS_CODE_NOT_IMPLEMENTED
    else
      @code = STATUS_CODE_CREATED
      database[posted_data.first[1..-1]] = posted_data.last
    end
    puts database
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
  end

  def handle_status_code_by_methods(request)
    unless @allowed_methods.include?(request.http_method)
      @code = STATUS_CODE_NOT_ALLOWED
    end
  end
end