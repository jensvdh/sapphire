module WebServer
  module Response
    # Class to handle 401 responses
    class Forbidden < Base
      def initialize(resource, options={})
        @headers = Hash.new()
        @headers['Content-Type'] = 'text/plain'
        @headers['Content-Length'] = "Forbidden access.".size
        super(resource, {:code => 403})
      end

      def get_body
        return "Forbidden access."
      end
    end
  end
end
