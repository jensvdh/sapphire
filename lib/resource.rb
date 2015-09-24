module WebServer
  class Resource
    attr_reader :request, :conf, :mimes
    def initialize(request, httpd_conf, mimes)
      @request = request
      @conf = httpd_conf
      @mimes = mimes
      @script_aliased = false
    end

    def protected?
      uri = @request.uri
      document_root = @conf.document_root
      if File.extname(uri) == ""
        directory = uri
      else
        directory = (uri.split("/").first uri.split("/").size - 1).join("/")
      end
      if directory.start_with? "/"
        File.exist?(directory + "/" + @conf.access_file_name)
      else
        File.exist?(document_root + directory + "/" + @conf.access_file_name)
      end
    end

    def script_aliased?
      uri = @request.uri
      document_root = @conf.document_root
      directory = ""
      filename = ""
      if (File.extname(uri) == "")
        filename = @conf.directory_index
        directory = uri
      else
        filename = uri.split("/").last
        directory = (uri.split("/").first uri.split("/").size - 1).join("/")
      end

      #check for script aliases
      @conf.script_aliases.each do |a|
        if directory.include? a
          document_root = ""
          return true
        end
      end
      return false
    end

    def resolve
      uri = @request.uri
      document_root = @conf.document_root
      directory = ""
      filename = ""
      if (File.extname(uri) == "")
        filename = @conf.directory_index
        directory = uri
      else
        filename = uri.split("/").last
        directory = (uri.split("/").first uri.split("/").size - 1).join("/")
      end

      #check for script aliases
      @conf.script_aliases.each do |a|
        if directory.include? a
          document_root = ""
          @script_aliased = true
          directory =  directory.gsub(a, @conf.script_alias_path(a))
        end
      end

      #check for aliases
      @conf.aliases.each do |a|
        if directory.include? a
          document_root = ""
          directory =  directory.gsub(a, @conf.alias_path(a))
        end
      end
      return document_root + directory + '/' + filename
    end

  end
end