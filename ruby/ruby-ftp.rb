#!/usr/bin/ruby
#
# ftp-ruby.rb version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'net/ftp'
 
HOST = ARGV[0]
 
if ARGV.empty? 
    puts "portscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "Usage:" 
    puts "ruby ftp.rb [FTP Server IP] ls - List contents of FTP Server"
    puts "ruby ftp.rb [FTP Server IP] get [remote filename] - Download file from FTP Server"
    puts "ruby ftp.rb [FTP Server IP] put [local filename] - Upload file to FTP Server"
    exit
end

print "Username: "  
USERNAME = STDIN.gets.chomp() 
print "Password: " 
`stty -echo`
PASSWORD = STDIN.gets.chomp()
`stty echo`

begin
if ARGV[1] == "ls"
  # dir list FTP server
  Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
  files = ftp.list
  puts "\r\nlist out files in root directory:"
  puts files
  end
elsif ARGV[1] == "get" 
  # download files
  TXT_FILE_OBJECT = ARGV[2]
  Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
  ftp.getbinaryfile(TXT_FILE_OBJECT)
  puts "\r\n"
  end
elsif ARGV[1] == "put"
  # upload files
  TXT_FILE_OBJECT = File.new(ARGV[2])
  Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
  ftp.putbinaryfile(TXT_FILE_OBJECT)
  puts "\r\n"
  end
else
  puts "\r\nError, your command must include ls, get or put."
end
rescue Exception => e
  puts "\r\n #{e.message}"  
end
