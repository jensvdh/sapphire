require 'socket'
#require all ruby files
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    attr_accessor :conf, :mimes
    DEFAULT_PORT = 2468

    #constructor
    def initialize(options={})
      config_file = File.open("config/jens.conf", "rb")
      contents = config_file.read
      config_file.close
      @conf = HttpdConf.new(contents)
      mime_types_file = File.open("config/mime.types", "rb")
      mime_content = mime_types_file.read
      @mimes = MimeTypes.new(mime_content)
      mime_types_file.close
      if @conf.port.nil?
        @conf.port = @DEFAULT_PORT
      end
      # Set up WebServer's configuration files and logger here
      # Do any preparation necessary to allow threading multiple requests
    end

    def start
      puts "Starting webserver on port #{@conf.port}"
      "waiting for connections.."
      server = TCPServer.open(@conf.port)
      loop do
        Thread.fork(server.accept) do |client|
          worker = Worker.new(client, self)
          worker.process_request
          puts "request handled"
          client.close
        end
      end
      # Begin your 'infinite' loop, reading from the TCPServer, and
      # processing the requests as connections are made
    end
    private
  end
end

WebServer::Server.new.start