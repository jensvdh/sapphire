require 'socket'
#require all ruby files
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    DEFAULT_PORT = 2468

    #constructor
    def initialize(options={})
      config_file = File.open("config/jens.conf", "rb")
      contents = config_file.read
      config_file.close
      @conf = HttpdConf.new(contents)
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
          #all code here lives in another threads
          client.puts("Hello, I'm Ruby TCP server", "I'm disconnecting, bye :*")
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