require 'socket'
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    DEFAULT_PORT = 2468

    def initialize(options={})
      # Set up WebServer's configuration files and logger here
      # Do any preparation necessary to allow threading multiple requests
      @descriptors = Array::new
      @serverSocket = TCPServer.new("", DEFAULT_PORT)
      @serverSocket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR,1)
      puts "Server Started on port #DEFAULT_PORT"
      @descriptors.push(@serverSocket)
    end

    def start
      # Begin your 'infinite' loop, reading from the TCPServer, and
      # processing the requests as connections are made
      while 1
	      res = select(@descriptors,nil,nil,nil)
	      if res != nil then
		      for sock in res[0]
			      if sock == @serverSocket
				      accept_new_connection
				      else sock.eof?
					str = puts "Connection closed #sock.peeraddr[2] : #sock.peeraddr[1]"
					broadcast_string(str,sock)
					sock.close
					@descriptors.delete(sock)
					else
						y = sock.gets()
						str = puts "[#sock.peeraddr[2] | #sock.peeraddr[1]], #y "
						braodcast_string(str,sock)
				end
				      
		      end
	      end
	      
		      
      end
      
    end

    private
    
    def bradcast_string(str, omit_sock)
	    @descriptors.each do |clisock|
	      if clisock != serverSocket && clisock != omit_sock
		    clisock.write(str)
	    end
	end
	    
    end
    
    def accept_new_connection
	    newsock = @serverocket.accept
	    @descriptors.push(newsock)
	    newsock.write("You are now connected to web server \n")
	    str = puts "Connection stablished #newsock.peeraddr[2] : #newsock.peeraddr[1]"
	    braodcast_string(str,newsock)
    end
    
    
  end
end

WebServer::Server.new.start
