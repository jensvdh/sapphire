require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration
    def initialize(httpd_file_content)
    end

    # Returns the value of the ServerRoot
    def server_root 
    end

    # Returns the value of the DocumentRoot
    def document_root
    end

    # Returns the directory index file
    def directory_index
    end

    # Returns the *integer* value of Listen
    def port
    end

    # Returns the value of LogFile
    def log_file
    end

    # Returns the name of the AccessFile 
    def access_file_name
    end

    # Returns an array of ScriptAlias directories
    def script_aliases
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(path)
    end

    # Returns an array of Alias directories
    def aliases
    end

    # Returns the aliased path for a given Alias directory
    def alias_path(path)
    end
  end
end
