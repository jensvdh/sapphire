module WebServer
  module Response
    # Class to handle 404 errors
    class NotFound < Base
      def initialize(resource, options={})
        super(resource, {:code => 404})
        @headers['Content-Length'] = "Page not found".size
        @headers['Content-Type'] = 'text/plain'
      end
      def get_body

        return "Page not found"
      end
    end
  end
end
