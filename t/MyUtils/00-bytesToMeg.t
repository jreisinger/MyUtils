#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use lib $ENV{HOME} . '/perl5lib';
use MyUtils qw(bytesToMeg);

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
