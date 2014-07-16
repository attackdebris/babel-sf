#!/usr/bin/ruby
#
# ftp-ruby.rb version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'net/ftp'
 
HOST = ARGV[0]
 
if ARGV.empty? or ARGV[0] == "-h" or ARGV[0] == "--h" or ARGV[0] == "-help" or ARGV[0] == "--help"
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "Usage:" 
    puts "  ruby ftp-ruby.rb [FTP Server IP] ls                    - List contents of FTP Server"
    puts "  ruby ftp-ruby.rb [FTP Server IP] get [remote filename] - Download file from FTP Server"
    puts "  ruby ftp-ruby.rb [FTP Server IP] put [local filename]  - Upload file to FTP Server"
elsif ARGV.length < 2
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, atleast 2 arguments are required, check your syntax"
elsif ARGV[1] != "ls" and ARGV[1] != "get" and ARGV[1] != "put"
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, your command must include ls, get or put."
elsif ARGV[1] == "ls" and ARGV.length > 2
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, only 2 arguments are required when using 'ls', check your syntax"
# ftp 'ls'
elsif ARGV[1] == "ls" and ARGV.length == 2
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    print "\r\nUsername: "  
    USERNAME = STDIN.gets.chomp() 
    print "Password: " 
    `stty -echo`
    PASSWORD = STDIN.gets.chomp()
    `stty echo`
    puts "\r\n"
    Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
    files = ftp.list
    puts "\r\n"
    puts "root directory file listing:"
    puts files
    end
elsif ARGV[1] == "get" or ARGV[1] == "put" and ARGV.length < 3
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, you need to specify a filename"
elsif ARGV[1] == "get" or ARGV[1] == "put" and ARGV.length > 3
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, only 3 arguments are required when using 'get' or 'put', check your syntax"
# ftp 'get'
elsif ARGV[1] == "get" and ARGV.length == 3 
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    print "\r\nUsername: "  
    USERNAME = STDIN.gets.chomp() 
    print "Password: " 
    `stty -echo`
    PASSWORD = STDIN.gets.chomp()
    `stty echo`
    puts "\r\n"    
    FILENAME = ARGV[2]
    Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
    ftp.getbinaryfile(FILENAME)
    puts "\r\nSuccessfully downloaded: #{FILENAME}"
    end
# ftp 'put'
elsif ARGV[1] == "put" and ARGV.length == 3
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    print "\r\nUsername: "  
    USERNAME = STDIN.gets.chomp() 
    print "Password: " 
    `stty -echo`
    PASSWORD = STDIN.gets.chomp()
    `stty echo`
    puts "\r\n"    
    FILENAME = File.new(ARGV[2])
    Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
    ftp.putbinaryfile(FILENAME)
    puts "\r\nSuccessfully uploaded: #{ARGV[2]}"
    end
end
