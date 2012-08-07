#!/usr/bin/env perl
#

use strict;
use warnings;
use Shell qw(ip);

my @ipa = ip 'a';

foreach (@ipa) {
    if ( /^\s+inet (9\.\d+\.\d+\.\d+)/ ) { print "$1\n"; }
}
