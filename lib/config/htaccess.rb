module WebServer
  class Htaccess
	  def initialize(valid_user_content)
	  end
	  
	  def auth_user_file
		  ".htpwd_file_name"
	  end
	  def auth_type
		  "Basic"
	  end
	  def auth_name
		  "This is the auth_name"
	  end
	  def require_user
		  "some_user"
	  end
	  def authorized?
		  true
	  end
	  def users
	  end
	  

  end
end