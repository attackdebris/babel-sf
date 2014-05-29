#!/usr/bin/perl -w
use Net::FTP;

$num_args = $#ARGV + 1;
$FTPSERVER=$ARGV[0];
$FILENAME=$ARGV[2];
if ($num_args == 0) {
	print"ftp-perl.pl - ( https://github.com/attackdebris/babel-sf )\n";
	print"\nUsage:"; 
        print"\nperl ftp-perl.pl [FTP Server IP] ls - List contents of FTP Server";	
	print"\nperl ftp-perl.pl [FTP Server IP] get [remote filename] - Download file from FTP Server";
	print"\nperl ftp-perl.pl [FTP Server IP] put [local filename] - Upload file to FTP Server\n";
}
elsif ($num_args < 2) {
	print"Too few arguments, please check your syntax.\n";
}
elsif ($ARGV[1] eq "ls") {
	print "ftp-perl.pl - ( https://github.com/attackdebris/babel-sf )\n\n";
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0)	
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
	my @filenames=$ftp->ls();
	print "root directory file listing:\n";
	foreach (@filenames)
	{
	   print $_, "\n";
	}
	$ftp->quit;
}
elsif ($ARGV[1] eq "get") {
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0)	
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
	print"Successfully transfered: $FILENAME\n";
	$ftp->quit;
}
elsif ($ARGV[1] eq "put") {
	$ftp=Net::FTP->new($FTPSERVER, Debug => 0)	
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
		or die "get failed, check your filename!", $ftp->message;
	print"Successfully transfered: $FILENAME\n";
	$ftp->quit;
}