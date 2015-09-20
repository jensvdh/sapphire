# The Request class encapsulates the parsing of an HTTP Request
module WebServer
  class Request
    attr_accessor :http_method, :uri, :version, :headers, :body, :params

    # Request creation receives a reference to the socket over which
    # the client has connected
    def initialize(socket)
      @headers = Hash.new
      @params = Hash.new
      @body = ""
      request_string = socket.read
      lines = request_string.split("\n")
      parse_initial_line(lines[0])
      line_index = 1
      line = lines[line_index]
      #headers
      while !line.strip.empty?
        parse_header_line(line)
        line_index += 1
        line = lines[line_index]
      end
      line_index += 1
      line = lines[line_index]
      while line != nil && !line.strip.empty?
        parse_body_line(line)
        line_index += 1
        line = lines[line_index]
      end
      @body.strip!
    end

    def parse_body_line(line)
      @body = @body + line + "\n"
    end

    def parse_header_line(line)
      key, value = line.split(":")
      key.strip!
      value.strip!
      key.upcase!
      key.gsub!('-','_')
      @headers[key] = value
    end

    def parse_initial_line(line)
      @http_method, @uri, @version = line.split(' ')
      if(@http_method == "GET")
        @uri, get_params_string = @uri.split('?')
        @params = parse_get_params(get_params_string)
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