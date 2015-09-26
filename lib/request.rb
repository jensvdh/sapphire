# The Request class encapsulates the parsing of an HTTP Request
module WebServer
  class Request
    attr_accessor :headers, :params, :uri, :body, :version, :http_method
    # Request creation receives a reference to the socket over which
    # the client has connected
    def initialize(socket)
      @headers = Hash.new
      @params = Hash.new
      @body = ""
      initial_line = socket.readline
      parse_initial_line(initial_line)
      line = socket.readline

      while (!line.strip.empty?) do
        puts line
        parse_header_line(line)
        line = socket.readline
      end

      #check if we have a content length header
      if !@headers["CONTENT_LENGTH"].nil?
        content_length = 0
        line = socket.readline
        content_length = content_length + line.length
        while (content_length < @headers["CONTENT_LENGTH"].to_i) do
          parse_body_line(line)
          line = socket.readline
          content_length = content_length + line.length
        end
        parse_body_line(line)
        @body.strip!
        puts @headers
      end
    end

    def parse_body_line(line)
      @body = @body + line
    end

    def parse_header_line(line)
      key, value = line.split(":")
      key.strip!
      value.strip!
      key.upcase!
      key.gsub!('-','_')
      @headers[key] = value
    end
    def get_content_from_buffer(socket)
    end

    def parse_initial_line(line)
      @http_method, @uri, @version = line.split(' ')
      if(@http_method == "GET")
        @uri, get_params_string = @uri.split('?')
        if !get_params_string.nil?
          @params = parse_get_params(get_params_string)
        end
      end
    end

    def parse_get_params(get_params_string)
      param_strings = get_params_string.split("&")
      param_strings.each do |param_string|
        key, value = param_string.split('=')
        @params[key] = value
      end
      return params
    end

    # I've added this as a convenience method, see TODO (This is called from the logger
    # to obtain information during server logging)
    def user_id
      # TODO: This is the userid of the person requesting the document as determined by
      # HTTP authentication. The same value is typically provided to CGI scripts in the
      # REMOTE_USER environment variable. If the status code for the request (see below)
      # is 401, then this value should not be trusted because the user is not yet authenticated.
      '-'
    end
  end
end