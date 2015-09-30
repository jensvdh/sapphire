require 'fileutils'
module WebServer
  class Logger
    # Takes the absolute path to the log file, and any options
    # you may want to specify.  I include the option :echo to 
    # allow me to decide if I want my server to print out log
    # messages as they get generated
    def initialize(log_file_path, options={})
      @mutex = Mutex.new
      @log_file_path = log_file_path
      #recursive logfile creation
      dirName = File.dirname(log_file_path);
      FileUtils.mkdir_p(dirName) unless File.exists?(dirName)
      File.new log_file_path,"w" unless File.exists?(log_file_path)
    end


    # Log a message using the information from Request and 
    # Response objects
    def log(request, response, client_ip)
      @mutex.synchronize do
        h = client_ip
        l = "-"
        t = Time.now.to_s
        r = request.initial_line.strip!
        u = request.get_remote_user
        s = response.code.split(" ")[0]
        b = response.get_content_length
        #puts "#{h} #{l} #{u} [#{t}] \"#{r}\" #{s} #{b}"
        puts "#{h} #{l} #{u} [#{t}] \"#{r}\" #{s} #{b}"
        File.open(@log_file_path, "a") do |file|
          file.write "#{h} #{l} #{u} [#{t}] \"#{r}\" #{s} #{b}" + "\n"
        end
      end
    end
  end
end
