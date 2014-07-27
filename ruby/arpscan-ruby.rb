#!/usr/bin/ruby
#
# arpscan-ruby.rb version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'socket'

network_interface = ARGV[0]

if ARGV[0] == "-h" or ARGV[0] == "--h" or ARGV[0] == "-help" or ARGV[0] == "--help"
    puts "arpscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "USAGE:" 
    puts "  ruby arpscan-ruby.rb"
    puts "  e.g. ruby portscan-ruby.rb"
elsif ARGV.length > 0
    puts "arpscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, no arguments are required, check your syntax"
else
    
return_ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
ip = return_ip.ip_address unless return_ip.nil?
ip = ip.rpartition(".")[0] +"."

s = UDPSocket.new    

# Yeah, it's not that smart it treats all IP addresses as class C
255.times do |i|
  next if i == 0
  s.send("abc", 0, ip +i.to_s, 53)
end

# Misses the later hosts unless we intoduce a delay
sleep(5)
f = File.open("/proc/net/arp", 'r')
data = f.read.split("\n")
f.close()

up_hosts = []

data.each do |line|
  entry = line.split(/\s+/)
  next if entry[3] == "00:00:00:00:00:00"
  next if entry[0] == "IP"
  up_hosts << [ :ip => entry[0], :mac => entry[3]]
end

puts "arpscan-ruby.rb ( https://github.com/attackdebris/babel-sf )"
puts "\r\nActive network hosts:"
puts "%-12s\t%s\n" % ["IP Address", "MAC Address"]
up_hosts.each do |host|
puts "%-12s\t%s\n" % [host[0][:ip], host[0][:mac]]
end
puts "\r\narpscan-ruby.rb scan done"
end