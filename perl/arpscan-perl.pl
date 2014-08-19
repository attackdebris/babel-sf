#!/usr/bin/perl
#
# arpscan-perl.pl version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#

#use warnings;
use strict;
use IO::Socket::INET;

require 'sys/ioctl.ph';

my $num_args = $#ARGV + 1;
my $int=$ARGV[0];
if ($ARGV[0] eq "-h" or $ARGV[0] eq "--h" or  $ARGV[0] eq "-help" or $ARGV[0] eq "--help"){
	print"arpscan-perl.pl ( https://github.com/attackdebris/babel-sf )\n";
	print"\nUSAGE:"; 
        print"\n  perl arpscan-perl.pl";
        print"\n  perl arpscan-perl.pl [interface]";
        print"\n  e.g. perl arpscan-perl.pl eth0\n";
        exit 0;
}
elsif ($num_args > 1) {
	print "arpscan-perl.pl ( https://github.com/attackdebris/babel-sf )\n\n";
	print"Too many arguments, please check your syntax.\n";
	exit 0;
}
elsif ($num_args == 0) {
	$int = 'eth0';
}

$| = 1;
print "arpscan-perl.pl ( https://github.com/attackdebris/babel-sf )\n";

my $full_ip = get_interface_address("$int");
my @split = split('\.', $full_ip);
my $ip = "$split[0].$split[1].$split[2]";

sub get_interface_address
{
my ($iface) = @_;
my $socket;
socket($socket, PF_INET, SOCK_STREAM, (getprotobyname('tcp'))[2]) || die "Unable to create a socket: $!\n";
my $buf = pack('a256', $iface);
if (ioctl($socket, SIOCGIFADDR(), $buf) && (my @address = unpack('x20 C4', $buf)))
{
return join('.', @address);
}
return undef;
}

my $buf="abc";
my $ipad;
my $macad;
my @arp;

for my $i (1..254) {
  my $sock = new IO::Socket::INET(PeerAddr=>"$ip.$i", PeerPort=> 53,
	PeerPort=> 53, 
	Proto=> "udp");
	$sock->send("$buf");
	close($sock);
 }
 sleep 5;

print "\nActive network hosts:";
print "\nIP Address\tMAC Address\n";

open(ARP,"</proc/net/arp");
@arp = <ARP>;
close(ARP);

foreach my $linein ( @arp ) {
  chomp($linein);
  next if $linein =~ /IP/i;
  $ipad  = (split(/\s+/,$linein))[0];
  $macad = (split(/\s+/,$linein))[3];
  if ($macad eq '00:00:00:00:00:00') {
  } else {
  print "$ipad \t$macad\n";
  }
}
print "\narpscan-perl.pl scan done\n";