module WebServer
  module Response
    # Class to handle 400 responses
    class BadRequest < Base
      def initialize(resource, options={})
        super(resource, {:code => 400})
        @message = "Bad Request"
        @headers["Content-Length"] = @message.bytesize
      end
      def get_body
        return @message
      end
    end
  end
end
