#!/usr/bin/python
#
# arpscan-python.py - Python 3 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

import socket
import time
import sys
import struct

instructions =	("arpscan-python.py ( https://github.com/attackdebris/babel-sf )" +\
		"\n" +\
		"\nUSAGE:" +\
		"\n  python arpscan-python.py" +\
		"\n  python arpscan-python.pl [interface]" +\
		"\n  e.g. python arpscan-python.py eth0")

def get_ip_address():
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
	s.connect(('<broadcast>', 0))
	return s.getsockname()[0]

if len(sys.argv) == 1:
	full_ip = get_ip_address()
	int_ip = [ byte for byte in full_ip.split('.') ]
	ip_addr = "%s.%s.%s." % (int_ip[0], int_ip[1], int_ip[2])
	for i in range(1,255):
		s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		ip = "%s%s" % (ip_addr, i)
		s.sendto("abc".encode('utf-8'), (ip, 53))
	s.close()
elif len(sys.argv) >2 or sys.argv[1] == "-h" or sys.argv[1] == "--h" or sys.argv[1] == "-help" or sys.argv[1] == "--help":
	print (instructions)
	sys.exit()
elif len(sys.argv) == 2:
	full_ip = get_ip_address(sys.argv[1])
	int_ip = [ byte for byte in full_ip.split('.') ]
	ip_addr = "%s.%s.%s." % (int_ip[0], int_ip[1], int_ip[2])
	for i in range(1,255):  
		s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 
		ip = "%s%s" % (ip_addr, i)
		s.sendto("abc".encode('utf-8'), (ip, 53))
	s.close()

# Read the arp cache from /proc
print ("arpscan-python.py ( https://github.com/attackdebris/babel-sf )")
time.sleep(5)
fp = open("/proc/net/arp", "r")
lines = fp.readlines()
fp.close()

print ("\r\nActive network hosts:")
print ("IP Address\tMAC Address")
  
for line in lines[1:]:
	parts = line.strip().split()
	if len(parts) != 6:
		continue
	if parts[3] != "00:00:00:00:00:00":
		ip = parts[0]
		mac = parts[3]
		print ("%s \t%s" % (ip, mac))
print ("\narpscan-python.py scan done")
