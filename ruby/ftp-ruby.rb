#!/usr/bin/ruby
#
# ftp-ruby.rb version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'net/ftp'
 
HOST = ARGV[0]
 
if ARGV.empty? 
    puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "Usage:" 
    puts "ruby ftp-ruby.rb [FTP Server IP] ls - List contents of FTP Server"
    puts "ruby ftp-ruby.rb [FTP Server IP] get [remote filename] - Download file from FTP Server"
    puts "ruby ftp-ruby.rb [FTP Server IP] put [local filename] - Upload file to FTP Server"
    exit
end
puts "ftp-ruby.rb ( https://github.com/attackdebris/babel-sf )"
print "\r\nUsername: "  
USERNAME = STDIN.gets.chomp() 
print "Password: " 
`stty -echo`
PASSWORD = STDIN.gets.chomp()
`stty echo`
puts "\r\n"

begin
if ARGV[1] == "ls"
  # dir list FTP server
  Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
  files = ftp.list
  puts "\r\n"
  puts "root directory file listing:"
  puts files
  end
elsif ARGV[1] == "get" 
  # download files
  FILENAME = ARGV[2]
  Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
  ftp.getbinaryfile(FILENAME)
  puts "\r\nSuccessfully downloaded: #{FILENAME}"
  end
elsif ARGV[1] == "put"
  # upload files
  FILENAME = File.new(ARGV[2])
  Net::FTP.open(HOST, USERNAME, PASSWORD) do |ftp|
  ftp.putbinaryfile(FILENAME)
  puts "\r\nSuccessfully uploaded: #{ARGV[2]}"
  end
else
  puts "\r\nError, your command must include ls, get or put."
end
rescue Exception => e
  puts "\r\n #{e.message}"  
end
