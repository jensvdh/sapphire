require_relative 'request'
require_relative 'response'

# This class will be executed in the context of a thread, and
# should instantiate a Request from the client (socket), perform
# any logging, and issue the Response to the client.
module WebServer
  class Worker
    # Takes a reference to the client socket and the logger object
    def initialize(client_socket, server)
      @socket = client_socket
      @server = server
    end

    # Processes the request
    def process_request
      puts "New Request received"
      req = Request.new(@socket)
      resource = Resource.new(req, @server.conf, @server.mimes)
      response = Response::Factory::create(resource)
      @socket.write(response.to_s)
    end

  end
end
