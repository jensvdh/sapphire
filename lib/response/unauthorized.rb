module WebServer
  module Response
    # Class to handle 401 responses
    class Unauthorized < Base
      def initialize(resource, options={})
        @realm = options[:realm]
        super(resource, {:code => 401})
        create_headers
      end
      def create_headers
        @headers["WWW-Authenticate"] = "Basic realm=\"#{@realm}\""
        @headers["Content-Length"] = 0
      end
    end
  end
end
