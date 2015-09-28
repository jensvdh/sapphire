module WebServer
  module Response
    # Class to handle 404 errors
    class Success < Base
      def initialize(resource, options={})
        super(resource, {:code => 200})
        path = @resource.resolve
        @file = File.open(path,"rb")
        create_headers
      end

      def create_headers
        extension = File.extname(@resource.resolve).split(".").last
        @headers['Content-Type'] = "#{@resource.mimes.for_extension(extension)}"
        @headers['Content-Length'] = @file.size
        @headers['Last-Modified'] = @file.mtime.to_s
      end

      def get_body
        return @file.read
      end
    end
  end
end

