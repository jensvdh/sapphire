require "base64"
require "digest/sha1"
module WebServer
  class Htpasswd

    def authorized_users
     @authorized_users
    end

    def authorized_users_array
      authorized_users_array = Array.new()
      @authorized_users.each do |key, value|
        authorized_users_array.push(key)
      end
      return authorized_users_array
    end

    def is_authenticated?(encrypted_string)
      decrypted_string = Base64.decode64(encrypted_string)
      username = decrypted_string.split(':')[0]
      received_password = decrypted_string.split(':')[1]
      encrypted_password = authorized_users[username]
      encrypted_password = encrypted_password.gsub(/{SHA}/, '')
      return encrypted_password == Digest::SHA1.base64digest(received_password)
    end

    def is_authorized?(encrypted_string)
      decrypted_string = Base64.decode64(encrypted_string)
      username = decrypted_string.split(':')[0]
      return authorized_users.has_key?(username)
    end


    def initialize(content)
      @authorized_users = Hash.new()
      content.each_line do |line|
        username, password = line.split(':')
        @authorized_users[username] = password
      end
    end
  end
end