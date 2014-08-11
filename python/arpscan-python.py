#!/usr/bin/python
#
# arpscan-python.py version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

import socket
import time
import sys

instructions =	"arpscan-python.py ( https://github.com/attackdebris/babel-sf )" +\
		"\n" +\
		"\nUSAGE:" +\
		"\n  ruby arpscan-python.py" +\
		"\n  e.g. ruby portscan-python.py" 

if len(sys.argv) != 1:
    print instructions
    sys.exit()
elif len(sys.argv) == 1:
    for i in range(1,255):  
      s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 
      #s.settimeout(0.5)
      ip = "192.168.1.%s" % i
      s.sendto("abc", (ip, 53))
      s.close()

# Read the arp cache from /proc
print "arpscan-python.py ( https://github.com/attackdebris/babel-sf )"
time.sleep(5)
fp = open("/proc/net/arp", "r")
lines = fp.readlines()
fp.close()

print "\r\nActive network hosts:"
print "IP Address\tMAC Address"
  
for line in lines[1:]:
  parts = line.strip().split()
  if len(parts) != 6:
    continue
  if parts[3] != "00:00:00:00:00:00":
    ip = parts[0]
    mac = parts[3]
    print ip+'\t'+mac
print "\narpscan-python.py scan done"