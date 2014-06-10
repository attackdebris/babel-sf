#!/usr/bin/ruby
#
# http-ruby.rb version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'webrick'

port_number = ARGV[0]

if ARGV.empty? or ARGV[0] == "-h" or ARGV[0] == "--h" or ARGV[0] == "-help" or ARGV[0] == "--help"
    puts "http-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "Usage:"
    puts "ruby http-ruby.rb [bind port]"
    puts "e.g. ruby http-ruby.rb 80"
elsif ARGV.length != 1
    puts "http-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, only 1 argument is required, check your syntax"
elsif ARGV.length == 1
    puts "Starting http-ruby.rb ( https://github.com/attackdebris/babel-sf )\r\n"
    puts "\r\nListening on port #{port_number}...\r\n"
    server = WEBrick::HTTPServer.new(:BindAddress => '0.0.0.0', :Port => port_number, :DocumentRoot => Dir.pwd)
    trap('INT') { server.shutdown }
    server.start
end