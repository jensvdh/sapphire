module WebServer
  module Response
    # Class to handle 304 responses
    class NotModified < Base
      def initialize(resource, options={})
        super(resource, {:code => 304})
      end
    end
  end
end
