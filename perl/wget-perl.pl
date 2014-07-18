#!/usr/bin/perl -w
#
# msf-bind_tcp.pl version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

use LWP::Simple; 

$num_args = $#ARGV + 1;
$HTTP_RESOURCE=$ARGV[0];
$LOCAL_FILE=$ARGV[1];

if ($num_args == 0 or $ARGV[0] eq "-h" or $ARGV[0] eq "--h" or  $ARGV[0] eq "-help" or $ARGV[0] eq "--help") {
	print"wget-perl.pl ( https://github.com/attackdebris/babel-sf )\n";
	print"\nUsage:"; 
        print"\n  perl wget-perl.pl [http(s) server resource] [local filename]";	
        print"\n  e.g. perl wget-perl.pl https://github.com/attackdebris/babel-sf/archive/master.zip master.zip\n"
}
elsif ($num_args != 2) {
	print"2 arguments are required, please check your syntax.\n";
}
elsif ($num_args == 2) {
	print "Starting wget-perl.pl ( https://github.com/attackdebris/babel-sf )\n\n";
	print "Attempting to download the following resource: $HTTP_RESOURCE\n";
	mirror("$HTTP_RESOURCE", "$LOCAL_FILE");
	print "Complete, resource saved as $LOCAL_FILE\n";
}