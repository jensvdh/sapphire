module WebServer
  class Htaccess
    def auth_user_file
      return @auth_user_file
    end

    def auth_type
      return @auth_type
    end

    def auth_name
      return @auth_name
    end


    def initialize(content)
      content.each_line do |line|
        key = line.split(' ', 2)[0]
        value = line.split(' ', 2)[1]
        value.strip!
        value.gsub!(/^\"|\"?$/, '')
        case key
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