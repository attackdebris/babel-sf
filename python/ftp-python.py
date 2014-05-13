#!/usr/bin/python
#
# ftp-python.py version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
instructions = 	"ftp-python.py - ( https://github.com/attackdebris/babel-sf )\n" +\
		"\nUsage:" +\
		"\npython ftp-python.py [FTP Server IP] ls - List contents of FTP Server" +\
		"\npython ftp-python.py [FTP Server IP] get [remote filename] - Download file from FTP Server"  +\
		"\npython ftp-python.py [FTP Server IP] put [local filename] - Upload file to FTP Server"
		
from ftplib import FTP
import sys

if len(sys.argv) <3:
	print instructions
elif sys.argv[2] =="ls" and len(sys.argv) ==3:
	FTPSERVER=sys.argv[1]
	ftp=FTP(FTPSERVER)
	USERNAME = raw_input('Username: ')
	PASSWORD = raw_input('Password: ')
	ftp.login(USERNAME,PASSWORD)
	print "root directory file listing:"
	ftp.retrlines('LIST')
elif sys.argv[2] =="get" and len(sys.argv) <4:
	print "You need to specify a filename."
elif sys.argv[2] =="get" and len(sys.argv) ==4:
	FTPSERVER=sys.argv[1]
	FILENAME=sys.argv[3]
	ftp=FTP(FTPSERVER)	
	USERNAME = raw_input('Username: ')
	PASSWORD = raw_input('Password: ')
	ftp.login(USERNAME,PASSWORD)	
	ftp.retrbinary(('RETR ' + FILENAME), open(FILENAME, 'wb').write)
	print "Successfully downloaded: " + FILENAME 
elif sys.argv[2] =="put" and len(sys.argv) <4:
	print "You need to specify a filename."
elif sys.argv[2] =="put" and len(sys.argv) ==4:
	FTPSERVER=sys.argv[1]
	FILENAME=sys.argv[3]
	ftp=FTP(FTPSERVER)	
	USERNAME = raw_input('Username: ')
	PASSWORD = raw_input('Password: ')
	ftp.login(USERNAME,PASSWORD)
	ftp.storlines("STOR " + FILENAME, open(FILENAME, 'r'))
	print "Successfully uploaded: " + FILENAME
else:
	print "Error, please check your syntax."