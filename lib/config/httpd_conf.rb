require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration
    def initialize(content)
      content = content.split("\n")
      content.delete_if{|m| m.length == 0 || m =~ /^#/}
      @script_aliases = Hash.new
      @aliases = Hash.new
      content.each do |line|
        key, value  = line.split(" ", 2)
        value.strip!
        value.gsub!(/^\"|\"?$/, '')
        case key
          when "ServerRoot"
            @server_root = value
          when "DocumentRoot"
            @document_root = value
          when "DirectoryIndex"
            @directory_index = value
          when "Listen"
            @port = value
          when "LogFile"
            @log_file = value
          when "AccessFileName"
            @access_file_name = value
          when "ScriptAlias"
            key, value = value.split(' "')
            value.strip!
            value.gsub!(/^\"|\"?$/, '')
            @script_aliases[key] = value
          when "Alias"
            key, value = value.split(' "')
            value.strip!
            value.gsub!(/^\"|\"?$/, '')
            @aliases[key] = value
        end
      end
    end

    # Returns the value of the ServerRoot
    def server_root
      return @server_root
    end

    # Returns the value of the DocumentRoot
    def document_root
      return @document_root
    end

    # Returns the directory index file
    def directory_index
      return @directory_index
    end

    # Returns the *integer* value of Listen
    def port
      return @port.to_i
    end

    # Returns the value of LogFile
    def log_file
      return @log_file
    end

    # Returns the name of the AccessFile
    def access_file_name
      return @access_file_name
    end

    # Returns an array of ScriptAlias directories
    def script_aliases
      arr = Array.new
      @script_aliases.each do |key, value|
        arr.push(key)
      end
      return arr
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(path)
      return @script_aliases[path]
    end

    # Returns an array of Alias directories
    def aliases
      arr = Array.new
      @aliases.each do |key, value|
        arr.push(key)
      end
      return arr
    end

    # Returns the aliased path for a given Alias directory
    def alias_path(path)
      return @aliases[path]
    end
  end
end