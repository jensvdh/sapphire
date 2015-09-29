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

      def create_status_line
        return @version + " " + @code
      end

      def to_s
        str = ""
        str = create_status_line + "\r\n"
        @headers.each do |key, value|
          str = str + key.to_s + ": " + value.to_s + "\r\n"
        end
        str = str + "\r\n" + get_body
      end

      def get_body
        return ''
      end
    end
  end
end
