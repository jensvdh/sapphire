module WebServer
  module Response
    # Class to handle 400 responses
    class BadRequest < Base
      def initialize(resource, options={})
        @headers = Hash.new()
        @message = "Bad Request"
        @headers["Content-Length"] = @message.bytesize
        super(resource, {:code => 400})
      end
      def get_body
        return @message
      end
    end
  end
end
