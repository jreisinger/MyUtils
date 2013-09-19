#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

# Load module from repository not from system's @INC
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname( dirname abs_path $0) . '/lib';
use Local::OS qw(bytesToMeg);    # <= tested function(s)

my %MB = (
    0         => '0.00',
    1         => '0.00',
    123457    => 0.12,
    999999999 => 953.67,
);

for ( sort keys %MB )
{
    is( bytesToMeg($_), $MB{$_}, "Convert $_ bytes to $MB{$_} MB" );
}

done_testing();
