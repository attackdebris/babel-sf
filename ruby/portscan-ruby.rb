#!/usr/bin/ruby
#
# Base code from https://gist.github.com/jstorimer/3522068
#
# babel-sf portscan-ruby.rb
# version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'socket'

# Set up the parameters.
HOST = ARGV[0]
# Port ranges can also be specified as a range i.e. 21..23
PORT_RANGE = 21, 22, 23, 25, 53, 80, 135, 139, 443, 445, 1433, 3306, 3389 
TIME_TO_WAIT = 5 # seconds
TIME = Time.now.strftime("%Y-%m-%d %H:%M")

if ARGV.empty? 
    puts "Usage: ruby portscan.rb [target]"
    puts "e.g. ruby portscan.rb attackdebris.com"
    exit
end

# Create a socket for each port and initiate the nonblocking
# connect.
sockets = PORT_RANGE.map do |port|
  socket = Socket.new(:INET, :STREAM)
  remote_addr = Socket.sockaddr_in(port, HOST)

  begin
    socket.connect_nonblock(remote_addr)
  rescue Errno::EINPROGRESS
    # EINPROGRESS tells us that the connect cannot be completed immediately,
    # but is continuing in the background.
  end
  socket
end

# Set the expiration.
expiration = Time.now + TIME_TO_WAIT
# Header
puts "Starting portscan-ruby.rb ( https://github.com/attackdebris/babel-sf ) at #{TIME}"
puts "Scan report for #{HOST}"
puts "PORT   STATE"

loop do
  # We call IO.select and adjust the timeout each time so that we'll never
  # be waiting past the expiration.
  _, writable, _ = IO.select(nil, sockets, nil, expiration - Time.now)
  break unless writable

  writable.each do |socket|
    begin
      socket.connect_nonblock(HOST)
    rescue Errno::EISCONN
      # EISCONN tells us that the socket is already connected. Count this as a success.
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

