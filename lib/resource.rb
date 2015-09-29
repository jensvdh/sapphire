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
      path = resolve
      path = File.dirname(path)
      File.exist?(path + "/" + @conf.access_file_name)
    end

    def script_aliased?
      uri = @request.uri
      if (File.extname(uri) == "")
        directory = uri
      else
        directory = (uri.split("/").first uri.split("/").size - 1).join("/")
      end

      #check for script aliases
      @conf.script_aliases.each do |a|
        if !directory.end_with? '/'
          directory = directory + '/'
        end
        if directory.include? a
          return true
        end
      end
      return false
    end

    def resolve
      uri = @request.uri
      document_root = @conf.document_root
      if (File.extname(uri) == "" && !script_aliased?)
        filename = @conf.directory_index
        directory = uri
      else
        filename = uri.split("/").last
        directory = (uri.split("/").first uri.split("/").size - 1).join("/")
      end

      #check for script aliases
      @conf.script_aliases.each do |a|
        if !directory.end_with? '/'
          directory = directory + '/'
        end
        if directory.include? a
          document_root = ""
          @script_aliased = true
          directory =  directory.gsub(a, @conf.script_alias_path(a))
        end
      end

      @conf.aliases.each do |a|
        if !directory.end_with? '/'
          directory = directory + '/'
        end
        if directory.include? a
          document_root = ""
          directory =  directory.gsub(a, @conf.alias_path(a))
        end
      end
      #TODO clean this up
      directory.chomp!('/')
      document_root.chomp!('/')
      if directory == ""
        return document_root + '/' +filename
      else
        return document_root + directory + '/' +filename
      end
    end
  end
end