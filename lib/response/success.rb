require "shellwords"
module WebServer
  module Response
    # Class to handle 404 errors
    class Success < Base
      def initialize(resource, options={})
        @resource = resource
        @headers = Hash.new()
        path = @resource.resolve
        if !resource.script_aliased?
          file = File.open(path,"rb")
          @message = file.read
          extension = File.extname(@resource.resolve).split(".").last
          @headers['Content-Type'] = @resource.mimes.for_extension(extension)
          @headers['Last-Modified'] = file.mtime.to_s
          file.close
        else
          handle_cgi
        end
        @headers['Content-Length'] = @message.bytesize
        if(@headers['Content-Type'].nil?)
          @headers['Content-Type'] = 'text/plain'
        end
        super(resource, {:code => 200})
      end

      def handle_cgi
        command = get_command
        if !@resource.request.params.nil?
          params = @resource.request.params.values.join(" ")
        end

        IO.popen(command + " " + Shellwords.escape(@resource.resolve)+" " + params) do |io|
          #write the request body into CGI
          io.write @resource.request.body
          parse_script_output(io)
        end
      end

      def parse_header_line(line)
        key, value = line.split(": ")
        key.strip!
        value.strip!
        @headers[key] = value
      end

      def parse_script_output(io)
        #skip the first line
        line = io.readline

        #empty output is possible
        if line.nil?
          return
        end

        while (!line.strip.empty? && (line.split(": ").length > 1)) do
          puts line
          parse_header_line(line)
          line = io.readline
        end

        @message = ""
        begin
          line = io.readline
          while (!line.strip.empty?) do
            @message = @message + line + "\n"
            line = io.readline
          end
        rescue
        end
      end

      def get_command
        path = @resource.resolve
        file = File.open(path,"rb")
        first_line = file.readline
        first_line.strip!
        return first_line[2..-1]
      end


      def get_body
        if(@resource.request.http_method == "HEAD")
          return ""
        else
          return @message
        end
      end
    end
  end
end

