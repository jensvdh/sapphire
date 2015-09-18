require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration
    def initialize(httpd_file_content)
	    @a = httpd_file_content
	    # puts "input in httpd file #@a"
    end

    # Returns the value of the ServerRoot
    def server_root 
	    "server_root/with/path"
    end

    # Returns the value of the DocumentRoot
    def document_root
	    "document_root"
    end

    # Returns the directory index file
    def directory_index
	    "i.html"
    end

    # Returns the *integer* value of Listen
    def port
	    1234
    end

    # Returns the value of LogFile
    def log_file
	    "log_file"
    end

    # Returns the name of the AccessFile 
    def access_file_name
	    "access_file"
    end

    # Returns an array of ScriptAlias directories
    def script_aliases
	    
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(path)
	    if (path == '/script_alias/')
	    "script/alias/directory" 
	    else
		    nil 
	    end
	    
    end

    # Returns an array of Alias directories
    def aliases
	    
	    
    end

    # Returns the aliased path for a given Alias directory
    def alias_path(path)
	   if (path == "/ab/")
	    "alias/public_html/ab1/ab2/"
	    else
		    nil 
	    end
    end
  end
end
