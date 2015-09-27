module WebServer
  module Response
    # Class to handle 401 responses
    class Forbidden < Base
      def initialize(resource, options={})
        super(resource, {:code => 403})
      end

      def get_body
        @headers['Content-Length'] = "Forbidden access.".size
        return "Forbidden access."
      end
    end
  end
end
