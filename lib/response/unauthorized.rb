module WebServer
  module Response
    # Class to handle 401 responses
    class Unauthorized < Base
      def initialize(resource, options={})
        super(resource, {:code => 401})
        create_headers
      end
      def create_headers
        @headers["WWW-Authenticate"] = 'Basic realm="Jens & Abhilash CSC 667 server."'
        @headers["Content-Length"] = 0
      end
    end
  end
end
