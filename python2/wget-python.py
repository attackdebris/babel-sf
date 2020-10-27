#!/usr/bin/python
#
# wget-python.py version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

import sys
import urllib

instructions = "wget-python.py ( https://github.com/attackdebris/babel-sf )\n" +\
"\nUsage:" +\
"\n  python wget-python.py [HTTP(S) server resource] [local filename]" +\
"\n  e.g. python wget-python.py https://github.com/attackdebris/babel-sf/archive/master.zip master.zip"

if len(sys.argv) !=3:
  print instructions
  sys.exit()
elif len(sys.argv) ==3:
  HTTP_RESOURCE=sys.argv[1]
  LOCAL_FILE=sys.argv[2]
  print "Starting wget-python.py ( https://github.com/attackdebris/babel-sf )\n"
  print "Attempting to download the following resource: " + HTTP_RESOURCE
  urllib.urlretrieve(HTTP_RESOURCE, LOCAL_FILE)
  print "Complete, resource saved as: " + LOCAL_FILE
