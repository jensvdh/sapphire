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
      bad_request = false
      begin
        req = Request.new(@socket)
      rescue Exception => ex
        bad_request = true
        response = Response::Factory::bad_request(ex)
        @socket.write(response.to_s)
      end
      if(bad_request == false)
        resource = Resource.new(req, @server.conf, @server.mimes)
        response = Response::Factory::create(resource)
        @socket.write(response.to_s)
      end
    end

  end
end
