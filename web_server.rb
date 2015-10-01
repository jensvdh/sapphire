require 'socket'
#require all ruby files
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    attr_accessor :conf, :mimes, :logger

    #constructor
    def initialize(options={})
      config_file = File.open("config/sample.conf", "rb")
      contents = config_file.read
      config_file.close
      @conf = HttpdConf.new(contents)
      mime_types_file = File.open("config/mime.types", "rb")
      mime_content = mime_types_file.read
      @mimes = MimeTypes.new(mime_content)
      mime_types_file.close
      # Set up WebServer's configuration files and logger here
      @logger = Logger.new(@conf.log_file)
    end

    def start
      puts "Starting webserver on port #{@conf.port}"
      server = TCPServer.open(@conf.port)
      puts "Server is now accepting connections..."
      loop do
        Thread.fork(server.accept) do |client|
          worker = Worker.new(client, self)
          worker.process_request
          client.close
        end
      end
    end
  end
end

WebServer::Server.new.start

