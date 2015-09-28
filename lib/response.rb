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
      'Server' => 'Jens & Abhilash CSC 667 server.',
      'Content-Type' => 'text/plain'
    }

    module Factory
      def self.create(resource)
        #check if the file exists
        path = resource.resolve
        if !is_found(path)
          return Response::NotFound.new(resource)
        else
          if(!resource.protected?)
            return Response::Success.new(resource)
          else
            htaccess_path = File.dirname(path) + '/' + resource.conf.access_file_name
            htaccess_file = File.open(htaccess_path, "rb")
            file_content = htaccess_file.read
            htaccess_file.close
            access = Htaccess.new(file_content)
            if(access.require_user == 'valid-user')
              if resource.request.headers['AUTHORIZATION'].nil?
                return Response::Unauthorized.new(resource, {:realm => access.auth_name})
              else
                #we will check the password here
                encrypted_string = resource.request.headers['AUTHORIZATION'].split(" ").last
                if(access.authenticated?(encrypted_string))
                  return Response::Success.new(resource)
                else
                  return Response::Forbidden.new(resource)
                end
              end
            else
              return Response::Success.new(resource)
            end
          end
        end
      end

      def is_found(path)
        return !File.exists?(path)
      end

      def has_protected_response?(resource)

      end

      def self.error(resource, error_object)
        #Response::ServerError.new(resource, exception: error_object)
      end
    end
  end
end
