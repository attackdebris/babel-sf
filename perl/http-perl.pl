#!/usr/bin/perl -w
#
# http-perl.pl version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

use warnings;
use strict;
use IO::All;

my $num_args = $#ARGV + 1;
if ($num_args == 0 or $ARGV[0] eq "-h" or $ARGV[0] eq "--h" or  $ARGV[0] eq "-help" or $ARGV[0] eq "--help") {
	print"http-perl.pl ( https://github.com/attackdebris/babel-sf )\n";
	print"\nUsage:"; 
        print"\nperl http-perl.pl [port number]";
	print"\nperl http-perl.pl e.g. perl http-perl.pl 8080\n";
}
elsif ($num_args > 1) {
	print"Only 1 argument is required, please check your syntax.\n";
}
elsif ($num_args == 1) {
	my $port_number = $ARGV[0];
	print"Starting http-perl.pl ( https://github.com/attackdebris/babel-sf )\n\n";
	print"[Note: Browsing to the root page (e.g. http://192.168.0.1:8080/) will always receive a reset!]\n";
	print"[Reading files: Files can be viewed by appending filename to URL e.g. http://192.168.0.1/[my_filename]]\n";
	print"[Downloading files: Files can be downloaded via 'wget' e.g. wget http://192.168.0.1/[my_filename]]\n";
	print"\nListening on port $port_number...\n";
	io("0.0.0.0:$port_number")->fork->accept->(sub { $_[0] < io(-x $1 ? "./$1 |" : $1) if /^GET \/(.*) / });
}