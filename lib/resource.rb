module WebServer
  class Resource
    attr_reader :request, :conf, :mimes

    def initialize(request, httpd_conf, mimes)
      @request = request
      #puts "value in request variable is #@request"
      @conf = httpd_conf
      #puts "value in conf variable is #@conf"
      @mimes = mimes
      #puts "value in mimes variable is #@mimes"
    end
    def resolve
	  
    end
    def script_aliased?
	   false
		    
    end
    def protected?
	    false
    end
  end
end
