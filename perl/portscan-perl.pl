#!/usr/bin/perl -w
#
# portscan-perl.pl version 0.3
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
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
	print"\nUSAGE 'common ports' scan (default):"; 
        print"\n  perl portscan-perl.pl [target]";
	print"\n  e.g. perl portscan-perl.pl 192.168.0.1";
	print"\nPORT SPECIFICATION (optional):";
	print"\n  -p <port ranges>: Only scan specified ports";
	print"\n  e.g. -p 20-22";
	print"\n  e.g. -p 20,21,22\n";
}
elsif ($num_args > 3) {
	print "portscan-perl.pl ( https://github.com/attackdebris/babel-sf )\n\n";
	print"Too many arguments, please check your syntax.\n";
	exit 0
}
elsif ($ARGV[0] eq "-p" and $num_args ne 3 ) {
	print "portscan-perl.pl ( https://github.com/attackdebris/babel-sf )\n\n";
	print "You need to specify a port range and target host\n";
	exit 0;
}
elsif ($ARGV[0] eq "-p" and $num_args eq 3 ) {
	if ($ARGV[1] =~ /-/) {
	  my @ports = split /-/, $ARGV[1];
	  our $lport = $ports[0];
	  our $hport = $ports[1];
	  our $target = $ARGV[2];
	  our $ip = inet_ntoa(inet_aton($target));
	  &portscan_range_engine($lport, $hport, $target, $ip);
	}
	elsif ($ARGV[1] =~ /,/) {
	  our @port = split /,/, $ARGV[1];
	  print "PORTS = @port\n";
	  our $target = $ARGV[2];
	  our $ip = inet_ntoa(inet_aton($target));
	  &portscan_list_engine(@port, $target, $ip);
	}
	else {
	  our @port = $ARGV[1];
	  our $target = $ARGV[2];
	  our $ip = inet_ntoa(inet_aton($target));
	  &portscan_list_engine(@port, $target, $ip);
	  }
}
elsif ($num_args == 1) {
#Get host.
our $target = $ARGV[0];
our $ip = inet_ntoa(inet_aton($target));
my $ports = '21,22,23,25,53,80,135,139,443,445,1433,1521,3306,3389';
our @port = split(',', $ports);
&portscan_list_engine(@port, $target, $ip);
}

sub portscan_list_engine 
{
print "Starting portscan-perl.pl ( https://github.com/attackdebris/babel-sf ) at $date\n";
if (($main::target) eq ($main::ip)) {
print "Scan report for $main::target\n";
}
else {
print "Scan report for $main::target ($main::ip)\n";
}
print "PORT   STATE\n";
foreach my $i (@main::port) {
my $socket;
my $success = eval {
	$socket = IO::Socket::INET->new(
		PeerAddr 	=> $main::target, 
		PeerPort 	=> $i,#@main::port, 
		Proto 	=> 'tcp',
		Timeout => 2
	) 
};
		
#If the port was opened, say it was and close it.
if ($success) {
	print "$i/tcp open\n";#@main::port/tcp open\n";
	shutdown($socket, 2);
}
}
#Exit.
print "\nportscan-perl.pl scan done\n";
exit 0;
}

sub portscan_range_engine
{

#Auto-flush.
$| = 1;

#Parent thread has no parent.
my $parent = 0;

#We need a place to store child PIDs.
my @children = ();

#Port scan host.
print "Starting portscan-perl.pl ( https://github.com/attackdebris/babel-sf ) at $date\n";
if (($main::target) eq ($main::ip)) {
print "Scan report for $main::target\n";
}
else {
print "Scan report for $main::target ($main::ip)\n";
}
print "PORT   STATE\n";
my $port;
FORK: for ($port=$main::lport; $port<=$main::hport; $port++) {
	#Fork.
	my $oldpid = $$;
	my $pid = fork;
	
	#If fork failed...
	if (not defined $pid) {
		#If resource is not available...
		if ($! =~ /Resource temporarily unavailable/) {
			while (my $child = shift @children) {
			waitpid $child, 0;
			}		
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
			PeerAddr 	=> $main::target, 
			PeerPort 	=> $port, 
			Proto 	=> 'tcp',
			Timeout => 2
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

	while (my $child = shift @children) {
	  waitpid $child, 0;
	}
}
sleep(3);
print "\nportscan-perl.pl scan done\n";
}