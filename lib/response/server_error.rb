module WebServer
  module Response
    # Class to handle 500 errors
    class ServerError < Base
      def initialize(resource, options={})
        super(resource, {:code => 500})
        @error_message = options[:exception].to_s
        @error_message = "<h1>500 - Internal server error occured.</h1><h2> "+  @error_message + "</h2>"
        @headers['Content-Length'] = @error_message.bytesize
        @headers['Content-Type'] = 'text/html'
      end
      def get_body
        return @error_message
      end
    end
  end
end
