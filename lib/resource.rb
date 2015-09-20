module WebServer
  class Resource
    attr_reader :request, :conf, :mimes

    def initialize(request, httpd_conf, mimes)
      @request = request
      @conf = httpd_conf
      @mimes = mimes
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