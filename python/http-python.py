#!/usr/bin/python
#
# http-python.py version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
# really simple syntax/not really required by added for completeness
#

import sys
import SimpleHTTPServer
import SocketServer

instructions = 	"http-python.py ( https://github.com/attackdebris/babel-sf )\n" +\
		"\nUsage:" +\
		"\npython http-python.py [bind port]" +\
		"\ne.g. python http-python.py 8080"

if len(sys.argv) !=2 or sys.argv[1] == "-h" or sys.argv[1] == "--h" or sys.argv[1] == "-help" or sys.argv[1] == "--help":
  print instructions
  sys.exit()
elif len(sys.argv) ==2:
  PORT_NUMBER=int(sys.argv[1])
  Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
  httpd = SocketServer.TCPServer(("", PORT_NUMBER), Handler)
  print "Starting http-python.py ( https://github.com/attackdebris/babel-sf )\n"
  print ("Listening on port %s..." % (PORT_NUMBER))
  httpd.serve_forever()