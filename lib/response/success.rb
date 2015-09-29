require "shellwords"
module WebServer
  module Response
    # Class to handle 404 errors
    class Success < Base
      def initialize(resource, options={})
        @resource = resource
        super(resource, {:code => 200})
        path = @resource.resolve
        if !resource.script_aliased?
          @file = File.open(path,"rb")
          create_headers
        else
          handle_cgi
        end
      end

      def handle_cgi
        command = get_command
        if !@resource.request.params.nil?
          params = @resource.request.params.values.join(" ")
        end


        IO.popen(command + " " + Shellwords.escape(@resource.resolve)+" " + params) do |io|
          #write the request body into CGI
          io.write @resource.request.body

          #return the output from the CGI
          result = io.read

          @message = result
          @headers['Content-Length'] = result.bytesize
          @headers['Content-Type'] = 'text/plain'
        end
      end

      def get_command
        path = @resource.resolve
        file = File.open(path,"rb")
        first_line = file.readline
        first_line.strip!
        return first_line[2..-1]
      end

      def create_headers
        extension = File.extname(@resource.resolve).split(".").last
        @headers['Content-Type'] = "#{@resource.mimes.for_extension(extension)}"
        @headers['Content-Length'] = @file.size
        @headers['Last-Modified'] = @file.mtime.to_s
      end

      def get_body
        if(@resource.request.http_method == "HEAD")
          return ""
        end
        if(!@resource.script_aliased?)
          return @file.read
        else
          return @message
        end
      end
    end
  end
end

