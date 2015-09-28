module WebServer
  class Htaccess
    def auth_user_file
      return @auth_user_file
    end

    def auth_type
      return @auth_type
    end

    def authenticated?(encrypted_string)
      if authorized?(encrypted_string)
        file = File.open(@auth_user_file, "rb")
        contents = file.read
        htpasswd = Htpasswd.new(contents)
        return htpasswd.is_authenticated?(encrypted_string)
      end
      return false
    end

    def authorized?(encrypted_string)
      #create a new htpasswd instance
      file = File.open(@auth_user_file, "rb")
      contents = file.read
      htpasswd = Htpasswd.new(contents)
      return htpasswd.is_authorized?(encrypted_string)
    end

    def users
      #create a new htpasswd instance
      file = File.open(@auth_user_file, "rb")
      contents = file.read
      htpasswd = Htpasswd.new(contents)
      return htpasswd.authorized_users_array
    end

    def auth_name
      return @auth_name
    end

    def require_user
      return @require_user
    end

    def initialize(content)
      content.each_line do |line|
        key, value = line.split(' ', 2)
        value.strip!
        value.gsub!(/^\"|\"?$/, '')
        #puts "Key Value pair"+key+":"+value
        case key
          when "Require"
            @require_user = value
          when "AuthUserFile"
            @auth_user_file = value
          when "AuthType"
            @auth_type = value
          when "AuthName"
            @auth_name = value
        end
      end
    end
  end
end