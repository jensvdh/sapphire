module WebServer
  module Response
    # Class to handle 201 responses
    class SuccessfullyCreated < Base
      def initialize(resource, options={})
        super(resource, {:code => 201})
      end
    end
  end
end
