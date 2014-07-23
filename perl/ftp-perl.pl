#!/usr/bin/perl -w
#
# msf-bind_tcp.pl version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

use Net::FTP;

$num_args = $#ARGV + 1;
$FTPSERVER=$ARGV[0];
$FILENAME=$ARGV[2];
if ($num_args == 0 or $ARGV[0] eq "-h" or $ARGV[0] eq "--h" or  $ARGV[0] eq "-help" or $ARGV[0] eq "--help"){
	print"ftp-perl.pl ( https://github.com/attackdebris/babel-sf )\n";
	print"\nUsage:"; 
        print"\n  perl ftp-perl.pl [FTP Server IP] ls - List contents of FTP Server";	
	print"\n  perl ftp-perl.pl [FTP Server IP] get [remote filename] - Download file from FTP Server";
	print"\n  perl ftp-perl.pl [FTP Server IP] put [local filename] - Upload file to FTP Server\n";
}
elsif ($num_args < 2) {
	print"Too few arguments, please check your syntax.\n";
}
elsif ($num_args > 3) {
	print"Too many arguments, please check your syntax.\n";
}
elsif ($ARGV[1] eq "ls") {
	print "ftp-perl.pl - ( https://github.com/attackdebris/babel-sf )\n\n";
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0, Timeout => 15)
	#$ftp=Net::FTP->new($FTPSERVER, Debug => 0)	
		or die "Cannot connect to $FTPSERVER; $0";
	print "Username: ";
	$username = <STDIN>;
	chomp ($username);
	print "Password: ";
	system('stty','-echo');
	$password = <STDIN>;
	chomp ($password);
	system('stty','echo');
	print "\n\n";
	$ftp->login("$username","$password")
		or die "Cannot login ", $ftp->message;
	my @filenames=$ftp->dir();
	print "root directory file listing:\n";
	foreach (@filenames)
	{
	   print $_, "\n";
	}
	$ftp->quit;
}
elsif ($ARGV[1] eq "get") {
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0, Timeout => 15)
		or die "Cannot connect to $FTPSERVER; $0";
	print "ftp-perl.pl - ( https://github.com/attackdebris/babel-sf )\n\n";
	print "Username: ";
	$username = <STDIN>;
	chomp ($username);
	print "Password: ";
	system('stty','-echo');
	$password = <STDIN>;
	chomp ($password);
	system('stty','echo');
	print "\n\n";
	$ftp->login("$username","$password")
		or die "Cannot login ", $ftp->message;
	$ftp->binary();
	$ftp->get($FILENAME)
		or die "get failed, check your filename!", $ftp->message;
	print"Successfully downloaded: $FILENAME\n";
	$ftp->quit;
}
elsif ($ARGV[1] eq "put") {
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0, Timeout => 15)	
		or die "Cannot connect to $FTPSERVER; $0";
	print "ftp-perl.pl - ( https://github.com/attackdebris/babel-sf )\n\n";
	print "Username: ";
	$username = <STDIN>;
	chomp ($username);
	print "Password: ";
	system('stty','-echo');
	$password = <STDIN>;
	chomp ($password);
	system('stty','echo');
	print "\n\n";
	$ftp->login("$username","$password")
		or die "Cannot login ", $ftp->message;
	$ftp->binary();
	$ftp->put($FILENAME)
		or die "put failed, check your filename!", $ftp->message;
	print"Successfully uploaded: $FILENAME\n";
	$ftp->quit;
}