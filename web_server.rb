require 'socket'

# --- func def for application

def application(name, &block)
  $app = Application.new
  $app.name = name
  $app.instance_eval(&block)
end


# --- class definition for Application

class Application
  attr_accessor :name
  def initialize
    @responders = {}
  end

  def open(client, path)
   responder = @responders[path]
   if responder
    responder.handle client
   else
    puts '>>> !no responder for ' + path
    @responders['/404'].handle client
   end
 end

 def respond(path, &block)
    @responders[path] = Responder.new(&block)
 end
end


# --- class definition for Responder

class Responder
  def initialize(&block)
   @block = block
  end

  def handle(client)
   @client = client
   instance_eval(&@block)
  end

 def say(words)
   @client.write(words)
   #puts words
  end
end


# --- DSL

application 'Test' do
  respond '/' do
   say 'you can try /work, /about or /ruby ;^D'
  end

  respond '/work' do
   say 'the work should be fun. like a game.'
  end

 respond '/about' do
   say 'a simple web server written in ruby-lang.'
 end

 respond '/ruby' do
   say 'Ruby is a dynamic, reflective, general purpose object-oriented programming language that combines syntax inspired by Perl with Smalltalk-like features. (from wikipedia)'
 end

 respond '/404' do
   say 'page not found'
 end
end


# --- Web Server: http://localhost:8080

server = TCPServer.new('localhost', 8080)
while client = server.accept
  peername = client.peeraddr[1,2].reverse.join ':'
  http_req = client.recv(1024)
  matches = /GET (.*) HTTP\/.*/i.match(http_req)
  if matches != nil && matches.length >= 2
   puts '>>> handle request ' + matches[1] + ' from ' + peername
   $app.open client, matches[1]
  else
   puts '>>> bad request from ' + peername
  end
  client.close
end