#!/usr/bin/python
# file: ftp.py
instructions = 	"ftp.py - A simple Python FTP client - Version 0.11, Matt Byrne (Oct 2011)\n" +\
		"\nUsage:" +\
		"\n./ftp.py [IP of FTP Server] - List contents of FTP Server" +\
		"\n./ftp.py [IP of FTP Server] [Filename to get] - Transfer a File" 

from ftplib import FTP
import sys
if len(sys.argv) <2:
	print instructions
elif len(sys.argv) ==2:
	FTPSERVER=sys.argv[1]
	ftp=FTP(FTPSERVER)	
	ftp.login()	
	ftp.retrlines('LIST')
elif len(sys.argv) ==3:
	FTPSERVER=sys.argv[1]
	FILENAME=sys.argv[2]
	ftp=FTP(FTPSERVER)	
	ftp.login()	
	ftp.retrbinary(('RETR ' + FILENAME), open(FILENAME, 'wb').write)
	print "Successfully transfered: " + FILENAME 
else:
	print "Too many variables...."
