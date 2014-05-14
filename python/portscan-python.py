#!/usr/bin/ruby
#
# Base code from https://gist.github.com/jstorimer/3522068
#
# portscan-python.py version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

import socket
import subprocess
import sys
import time

instructions = 	"portscan-python.py - ( https://github.com/attackdebris/babel-sf )\n" +\
		"\nUsage:" +\
		"\npython portscan-python.py [target]" +\
		"\ne.g. python portscan-python.py attackdebris.com"

if len(sys.argv) <2:
	print instructions
	sys.exit()
elif len(sys.argv) >2:
	print "Too many parameters, see usage"
elif len(sys.argv) ==2:
	HOST=sys.argv[1]
	#HOST  = socket.gethostbyname(remoteServer)
	print "Starting portscan-python.py ( https://github.com/attackdebris/babel-sf ) at " + (time.strftime("%Y-%m-%d %H:%M"))
	print "Scan report for {}".format(HOST)
for PORT in [21, 22, 23, 25, 53, 80, 135, 139, 443, 445, 1433, 3306, 3389]:  
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # increase timeout for high latency networks
        sock.settimeout(0.6500)
        result = sock.connect_ex((HOST, PORT))
        if result == 0:
            print "{}/tcp open".format(PORT)
        sock.close()
print "\r"
print "portscan-python.py scan complete"