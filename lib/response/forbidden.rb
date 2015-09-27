module WebServer
  module Response
    # Class to handle 401 responses
    class Forbidden < Base
      def initialize(resource, options={})
        super(resource, {:code => 403})
        @headers['Content-Type'] = 'text/plain'
        @headers['Content-Length'] = "Forbidden access.".size
      end

      def get_body
        return "Forbidden access."
      end
    end
  end
end
