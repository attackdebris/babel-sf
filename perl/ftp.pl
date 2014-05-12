#!/usr/bin/perl -w
use Net::FTP;

$num_args = $#ARGV + 1;
$FTPSERVER=$ARGV[0];
$FILENAME=$ARGV[1];
if ($num_args == 0) {
	print"ftp.pl - A simple Perl FTP client - Version 0.11, Matt Byrne (Oct 2011)\n";
	print"\nUsage:"; 
        print"\n./ftp.pl [IP of FTP Server] - List contents of FTP Server";	
	print"\n./ftp.pl [IP of FTP Server] [Filename to get] - Transfer a file\n";
}
elsif ($num_args == 1) {
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0)	
		or die "Cannot connect to $FTPSERVER; $0";
	$ftp->login("anonymous",'anonymous@blah.com')
		or die "Cannot login ", $ftp->message;	
	$ftp->cwd("/")
		or die "Cannot change working directory ", $ftp->message;
	print "Contents of FTP Server:\n";
	print ($ftp->ls ("/"));
#		or die "Cannot list current directory ", $ftp->message;
	print ("\n");
	$ftp->quit;
}
elsif ($num_args == 2) {
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0)	
		or die "Cannot connect to $FTPSERVER; $0";
	$ftp->login("anonymous",'anonymous@blah.com')
		or die "Cannot login ", $ftp->message;
	#Whilst not utilised at present the source dir can be changed below
	$ftp->cwd("/")
		or die "Cannot change working directory ", $ftp->message;
	$ftp->binary;
	$ftp->get($FILENAME)
		or die "get failed, check your filename!", $ftp->message;
	print"Successfully transfered: $FILENAME\n";
	$ftp->quit;
}
elsif ($num_args > 2) {
	print"Too many arguments...\n";
}
