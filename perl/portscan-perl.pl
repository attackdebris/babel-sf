#!/usr/bin/perl -w
#
# portscan-perl.pl version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
# Original/Source code by Jonathan Worthington
# http://www.jnthn.net/perlportscanner.shtml
#

use strict;
use warnings;
use IO::Socket::INET;
use POSIX qw(strftime);

my $date = strftime "%m-%d-%Y %H:%M", localtime;

my $num_args = $#ARGV + 1;
#$target = $ARGV[0];
if ($num_args == 0 or $ARGV[0] eq "-h" or $ARGV[0] eq "--h" or  $ARGV[0] eq "-help" or $ARGV[0] eq "--help"){
	print"portscan-perl.pl ( https://github.com/attackdebris/babel-sf )\n";
	print"\nUsage:"; 
        print"\n  perl portscan-perl.pl [target]";
	print"\n  perl portscan-perl.pl e.g. perl portscan-powershell.pl attackdebris.com\n";
}
elsif ($num_args > 1) {
	print"Only 1 argument is required, please check your syntax.\n";
	#exit;
}
elsif ($num_args == 1) {
#Auto-flush.
$| = 1;

#Get host.
my $target = $ARGV[0];

#Parent thread has no parent.
my $parent = 0;

#We need a place to store child PIDs.
my @children = ();

#Port scan host.
print "Starting portscan-perl.pl ( https://github.com/attackdebris/babel-sf ) at $date\n";
print "Scan report for $target\n";
print "PORT   STATE\n";
my $port;
FORK: for ($port=1; $port<=3389; $port++) {
	#Fork.
	my $oldpid = $$;
	my $pid = fork;
	
	#If fork failed...
	if (not defined $pid) {
		#If resource is not available...
		if ($! =~ /Resource temporarily unavailable/) {
			#Reap children.
			&DoReap;
			
			#Retry this port.
			$port --;
		} else {
			#Otherwise, show the error.
			die "Can't fork: $!\n";
		}
	} elsif ($pid == 0) {
		#This is the child. Save parent.
		$parent = $oldpid;
		
		#Clearup kids table.
		@children = ();
		
		#We don't want this thread to fork any more.
		last FORK;
	} else {
		#This is the parent. Store child pid to wait on it later.
		push @children, $pid;
	}
}

#If this is a child (i.e. it has a parent)...
if ($parent) {
	#Attempt to connect to $target on $port.
	my $socket;
	my $success = eval {
		$socket = IO::Socket::INET->new(
			PeerAddr 	=> $target, 
			PeerPort 	=> $port, 
			Proto 	=> 'tcp',
			Timeout => 1
		) 
	};
			
	#If the port was opened, say it was and close it.
	if ($success) {
		print "$port/tcp open\n";
		shutdown($socket, 2);
	}
	#Exit.
	exit 0;
} else {
	#If we're not the kid, we're the parent. Do a reap.
	&DoReap;
}

#This sub is the reaper.
sub DoReap {
	while (my $child = shift @children) {
		waitpid $child, 0;
	}
}
print "\nportscan-perl.pl scan done\n";
}