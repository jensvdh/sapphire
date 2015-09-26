module WebServer
  module Response
    # Class to handle 404 errors
    class NotFound < Base
      def initialize(resource, options={})
        super(resource, {:code => 404})
      end
      def get_body
        @headers['Content-Length'] = "Page not found".size
        return "Page not found"
      end
    end
  end
end
