require "base64"
# The Request class encapsulates the parsing of an HTTP Request
module WebServer
  class Request
    attr_accessor :headers, :params, :uri, :body, :version, :http_method, :initial_line
    # Request creation receives a reference to the socket over which
    # the client has connected
    def initialize(socket)
      @supported_http_verbs = Hash[
        "PUT" => true,
        "GET" => true,
        "POST" => true,
        "PATCH" => true,
        "OPTIONS" => true,
        "PURGE" => true,
        "HEAD" => true,
        "DELETE" => true,
        "COPY" => true,
        "LINK" => true,
        "UNLINK" => true,
        "LOCK" => true,
        "UNLOCK" => true,
        "PROPFIND" => true,
        "VIEW" => true
      ].freeze
      @headers = Hash.new
      @params = Hash.new
      @body = ""
      @initial_line = socket.readline
      parse_initial_line(@initial_line)
      if !is_first_line_valid?
        raise ArgumentError.new("Bad HTTP request")
      end
      line = socket.readline
      while (!line.strip.empty?) do
        parse_header_line(line)
        line = socket.readline
      end

      #check if we have a content length header
      if !@headers["CONTENT_LENGTH"].nil?
        if @headers["CONTENT_LENGTH"].to_i == 0
          return
        end
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

    def get_remote_user
      if headers['AUTHORIZATION'].nil?
        return "-"
      else
        encoded_string = headers['AUTHORIZATION']
        decoded_string = Base64.decode64(encoded_string.split(" ")[1])
        return decoded_string.split(":")[0]
      end
    end

    def parse_body_line(line)
      @body = @body + line
    end

    def parse_header_line(line)
      key, value = line.split(": ")
      key.strip!
      value.strip!
      key.upcase!
      key.gsub!('-','_')
      @headers[key] = value
    end

    def is_first_line_valid?
      return ((@version == "HTTP/1.1" || @version == "HTTP/1.0") && @uri =~ /^["\/"]/ && @supported_http_verbs[@http_method] == true)
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
  end
end