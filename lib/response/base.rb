module WebServer
  module Response
    # Provides the base functionality for all HTTP Responses 
    # (This allows us to inherit basic functionality in derived responses
    # to handle response code specific behavior)
    class Base
      include(Response)
      attr_reader :version, :code, :body

      def initialize(resource, options={})
        @code = options[:code].to_s + " "  + RESPONSE_CODES[options[:code]]
        #TODO respond with same version
        @version = DEFAULT_HTTP_VERSION
        if(!resource.nil?)
          @resource = resource
        end
      end

      def get_content_length
        if @content_length.nil? == true || @content_length == 0
          return "-"
        else
          return @content_length
        end
      end

      def create_status_line
        return @version + " " + @code
      end

      def to_s
        str = ''
        str = create_status_line + "\r\n"
        @headers.each do |key, value|
          str = str + key.to_s + ": " + value.to_s + "\r\n"
        end
        @body = get_body
        @content_length = @body.bytesize
        str = str + "\r\n" + @body
      end

      def get_body
        return ''
      end
    end
  end
end
