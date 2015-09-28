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
        begin
          path = resource.resolve
          #check for 404
          if !File.exists?(path)
            return Response::NotFound.new(resource)
          else
            #authenticate/authorize
            authenticated_response = is_authenticated?(resource)
            if(authenticated_response == true)
              response = get_file_response(resource)
              return response
            else
              return authenticated_response
            end
          end
        rescue Exception => ex
          error_response = self.error(resource, ex)
          return error_response
        end
      end

      def self.get_file_response(resource)
        #if we are dealing with a PUT, return 201
        if(resource.request.http_method == 'PUT')
          return SuccessfullyCreated.new(resource)
        end
        #check for 304
        if(!resource.request.headers["IF_MODIFIED_SINCE"].nil?)
          path = resource.resolve
          if(File.mtime(path).to_s == resource.request.headers["IF_MODIFIED_SINCE"])
            return NotModified.new(resource)
          end
        end
        return Success.new(resource)
      end

      def self.is_authenticated?(resource)
        path = resource.resolve
        #if its not protected, just early return instantly.
        if(!resource.protected?)
          return true
        end
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
              return true
            else
              return Response::Forbidden.new(resource)
            end
          end
        else
          return true
        end
      end
      def self.bad_request(error_object)
        Response::BadRequest.new(nil, {})
      end

      def self.error(resource, error_object)
        Response::ServerError.new(resource, {:exception => error_object})
      end
    end
  end
end
