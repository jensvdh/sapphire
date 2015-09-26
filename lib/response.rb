require_relative 'response/base'

module WebServer
  module Response
    DEFAULT_HTTP_VERSION = 'HTTP/1.1'

    RESPONSE_CODES = {
      200 => 'OK',
      201 => 'Successfully Created',
      304 => 'Not Modified',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not Found',
      500 => 'Internal Server Error'
    }.freeze

    DEFAULT_HEADERS = {
      'Date' => Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z'),
      'Server' => 'Jens & Abhilash CSC 667 server.'
    }

    module Factory
      def self.create(resource)
        #check if the file exists
        path = resource.resolve
        if !File.exists?(path)
          Response::NotFound.new(resource)
        else
          if(!resource.protected?)
            Response::Success.new(resource)
          else
            Response::Unauthorized.new(resource)
          end
        end
      end
      def self.error(resource, error_object)
        #Response::ServerError.new(resource, exception: error_object)
      end
    end
  end
end
