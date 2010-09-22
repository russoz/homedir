#!/usr/bin/perl

use strict;

use Fcntl qw(:flock);
use SOAP::Lite;
use Term::ANSIColor;

sub load_data ();
sub check_response ($);

my $ip = q();
my %conf;

%conf = load_data();
$conf{ip} = findIP() || die "ERROR: Cannot determine the IBM intranet IP number. Make sure you're connected.\n";

print "Attempting to register IP $conf{ip}\n";

print "Dynamic IP Update\t[ ";
if ( check_response( update_ip(%conf) ) ) {
  print color("bold green"), "Success" , color("reset"), " ]\n";
  exit 0;
}

print color("bold red"), "Failed", color("reset"), " ]\n";

exit 1;

sub load_data () {
  my %stuff = ();

  my $home = $ENV{'HOME'};
  my $file = "$home/etc/ibmdyn.conf";
  open(MYCONF, "$file") || die("can not open file: $file");
  flock(MYCONF, LOCK_EX);

  while (<MYCONF>) {
    chomp;
    my ($tag, $value) = (/^\s*(\S+)\s+(\S+)\s*$/);
    $stuff{$tag} = $value;
  }

  close(MYCONF);
  flock(MYCONF, LOCK_UN);

  return %stuff;
}

sub findIP{
  my $ipa = qx(/sbin/ip a | grep 'inet 9\.' );
  if ( $ipa =~ /\s+inet (9\.\d+\.\d+\.\d+)/ ) {
    return "$1";
  } else {
    return undef;
  }
}

sub update_ip {
  my $user = shift;
  my $pass = shift;
  my $hostname = shift;
  my $ip = shift;

  my $soap_response = SOAP::Lite
    -> uri('urn:CWADynamicDNSService')
    -> proxy('https://w3.webahead.ibm.com/dynamicdns/servlet/rpcrouter')
	-> updateIP($conf{user}, $conf{pass}, $conf{hostname}, $conf{ip});

  my $res = $soap_response->result;
  return $res;
}

sub check_response ($) {
  my $res = shift;
  return ($res =~ /success|true/i);
}

