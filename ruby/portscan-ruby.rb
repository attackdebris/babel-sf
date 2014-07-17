#!/usr/bin/ruby
#
# portscan-ruby.rb version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'socket'

TIME_TO_WAIT = 5 # seconds
TIME = Time.now.strftime("%Y-%m-%d %H:%M")

def portscan_engine()
# Set time_now due to fix timing issue and the expiration
time_now = Time.now
expiration = Time.now + TIME_TO_WAIT
# Header details
puts "Starting portscan-ruby.rb ( https://github.com/attackdebris/babel-sf ) at #{TIME}"
if HOST == RHOST
  puts "Scan report for #{HOST}"
else puts "Scan report for #{RHOST} (#{HOST})"
  puts "PORT   STATE"
end

sockets = PORT_RANGE.map do |port|
socket = Socket.new(:INET, :STREAM)
remote_addr = Socket.sockaddr_in(port, HOST)
  begin
    socket.connect_nonblock(remote_addr)
  rescue Errno::EINPROGRESS
    # EINPROGRESS tells us that the connect cannot be completed immediately
    # but is continuing in the background
  end
  socket
end

loop do
  # We call IO.select and adjust the timeout each time so that we'll never
  # be waiting past the expiration.
  _, writable, _ = IO.select(nil, sockets, nil, expiration - time_now)
  break unless writable
  writable.each do |socket|
    begin
      socket.connect_nonblock(HOST)
    rescue Errno::EISCONN
      # EISCONN tells us that the socket is already connected. Count this as a success
      puts "#{socket.remote_address.ip_port}\/tcp open"
      sockets.delete(socket)
    rescue Errno::EINVAL
      sockets.delete(socket)
    rescue Errno::ECONNREFUSED
      sockets.delete(socket)
    end    
  end
end

puts "\nportscan-ruby.rb scan done"
end

if ARGV.empty? or ARGV[0] == "-h" or ARGV[0] == "--h" or ARGV[0] == "-help" or ARGV[0] == "--help"
    puts "portscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "Default portscan usage:" 
    puts "  ruby portscan.rb [target]"
    puts "  e.g. ruby portscan.rb attackdebris.com"
    puts "PORT SPECIFICATION (optional):"
    puts "  -p <port ranges>: Only scan specified ports"
    puts "  e.g. -p 20-22"
    puts "  e.g. -p 20,21,22"
elsif ARGV[0] != "-p" && ARGV.length == 1
    # Name lookup
    RHOST = ARGV[0]
    HOST = IPSocket::getaddress(RHOST)
    PORT_RANGE = 21, 22, 23, 25, 53, 80, 135, 139, 443, 445, 1433, 3306, 3389 
    portscan_engine()
elsif ARGV.length > 3
    puts "portscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, maximum of 3 arguments accepted, check your syntax"
elsif ARGV[0] == "-p" && ARGV.length != 3
    puts "portscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nYou need to specify a port range and target host"
elsif ARGV[0] == "-p" && ARGV.length == 3
    # Name lookup
    RHOST = ARGV[2]
    HOST = IPSocket::getaddress(RHOST)
    # If single port entered, error
    unless ARGV[1].include? "-" or ARGV[1].include? ","
      puts "portscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
      puts "\r\n"
      puts "Single port scans not supported, include atleast 2 ports"
    end
    # If port range is entered split on comma
    if ARGV[1].include? ","
      PORT_RANGE = ARGV[1].split(/[,]/)
      portscan_engine()
    # If port range is entered strip hyphen for double-dot
    elsif ARGV[1].include? "-"
      TPORT_RANGE = ARGV[1].split('-')
      LPORT = TPORT_RANGE[0].to_i
      HPORT = TPORT_RANGE[1].to_i
      if HPORT > (LPORT+1018)
	puts "portscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
	puts "\r\n"
	puts "ruby can only open 1024 sockets, reduce your port range..."
      else
	PORT_RANGE=*(LPORT..HPORT)
	portscan_engine()
      end
    end
end