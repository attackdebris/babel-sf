#!/usr/bin/python
#
# portscan-python.py version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
# Base code from https://gist.github.com/jstorimer/3522068
#

import time
import socket
import sys
from multiprocessing import Pool

instructions =  "portscan-python.py ( https://github.com/attackdebris/babel-sf )\n" +\
                "\nUsage:" +\
                "\npython portscan-python.py [target]" +\
                "\ne.g. python portscan-python.py 192.168.0.1" +\
                "\nPORT SPECIFICATION (optional):" +\
                "\n  -p <port ranges>: Only scan specified ports" +\
                "\n  e.g. -p 20-22" +\
                "\n  e.g. -p 20,21,22"

if len(sys.argv) <2  or sys.argv[1] == "-h" or sys.argv[1] == "--h" or sys.argv[1] == "-help" or sys.argv[1] == "--help":
        print instructions
        sys.exit()
elif len(sys.argv) ==2 and sys.argv[1] != "-p":
	host = sys.argv[1]
	port_range = 21, 22, 23, 25, 53, 80, 135, 139, 443, 445, 1433, 3306, 3389
elif len(sys.argv) >4:
	print "portscan-python.py ( https://github.com/attackdebris/babel-sf )\n"
        print "Error, maximum of 3 arguments accepted, check your syntax"
        sys.exit()
elif sys.argv[1] == "-p" and len(sys.argv) != 4:
        host=sys.argv[1]
        print "portscan-python.py ( https://github.com/attackdebris/babel-sf )\n"
        print "You need to specify a port range and target host"
        sys.exit()
elif sys.argv[1] == "-p" and len(sys.argv) == 4:
	host = sys.argv[3]
	tport_range = sys.argv[2]
	if "," in tport_range:
	  port_range = map(int, tport_range.split(","))
	elif "-" in tport_range:
	  tport_range = tport_range.split("-",1)
	  lport = int(tport_range[0])
	  hport = int(tport_range[1])
	  port_range = range(lport, hport)
	else:
	  port = int(tport_range)
	  print "Starting portscan-python.py ( https://github.com/attackdebris/babel-sf ) at " + (time.strftime("%Y-%m-%d %H:%M"))
	  print "Scan report for {}".format(host)	  
	  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	  sock.settimeout(2)
	  result = sock.connect_ex((host, port))
	  if result == 0:
	    print "{}/tcp open".format(port)
	  sock.close()
	  print "\r"
	  print "portscan-python.py scan complete"
	  sys.exit()
def scan(arg):
    target_ip, port = arg

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(2)

    try:
        sock.connect((target_ip, port))
        sock.close()

        return port, True
    except (socket.timeout, socket.error):
        return port, False

if __name__ == '__main__':
    target_ip = host
    #num_procs = int(raw_input('Number of processes: '))
    num_procs = 40

    #ports = range(1, 1024)
    pool = Pool(processes=num_procs)
    print "Starting portscan-python.py ( https://github.com/attackdebris/babel-sf ) at " + (time.strftime("%Y-%m-%d %H:%M"))
    print "Scan report for {}".format(host)
    for port, status in pool.imap_unordered(scan, [(target_ip, port) for port in port_range]):
        if status == 1:
	  print "{}/tcp open".format(port)
	else: 
	  pass
     
print "\r"
print "portscan-python.py scan complete"