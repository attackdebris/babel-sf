#!/usr/bin/ruby
#
# Base code from https://gist.github.com/jstorimer/3522068
#
# wget-ruby.rb version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

require 'open-uri'

http_resource = ARGV[0]
local_file = ARGV[1]

if ARGV.empty? or ARGV[0] == "-h" or ARGV[0] == "--h" or ARGV[0] == "-help" or ARGV[0] == "--help"
    puts "wget-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\n"
    puts "Usage:"
    puts "ruby wget-ruby.rb [http(s) server resource] [local filename]"
    puts "e.g. ruby wget-ruby.rb https://github.com/attackdebris/babel-sf/archive/master.zip master.zip"
elsif ARGV.length != 2
    puts "wget-ruby.rb ( https://github.com/attackdebris/babel-sf )"
    puts "\r\nError, 2 arguments are required, a remote filename and a local filename, check your syntax"
elsif ARGV.length == 2
    puts "Starting wget-ruby.rb ( https://github.com/attackdebris/babel-sf )\r\n"
    puts "\r\nAttempting to download the following resource: #{http_resource}\r\n"
    File.open(local_file, "wb").write(open(http_resource, "rb").read)
    puts "Complete, resource saved as: #{local_file}"
end