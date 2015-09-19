require_relative "configuration"

# Parses, stores and exposes the values from the mime.types file
module WebServer
  class MimeTypes < Configuration
    def initialize(mime_file_content)
	@mimetype = Hash.new
	mimecontent = mime_file_content.split("\n")
	mimecontent.delete_if{|m| m.length == 0 || m =~ /^#/}
	mimecontent.each do |line|
		value, ext = line.split(" ",2)
			if (ext != nil)
			key = ext.split(" ")
			puts "#{key}"
			end
		key.each do |c|
		@mimetype[c] = value
		end
		end
	
	
	    
    end
    
    # Returns the mime type for the specified extension
	def for_extension(extension)
	if (@mimetype[extension] == nil  )
		"text/plain"
		else
		@mimetype[extension]
	end
	end
    end
end
