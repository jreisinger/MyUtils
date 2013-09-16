#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use lib $ENV{HOME} . '/perl5lib';
use MyUtils qw(nsLookup);

# Google and OpenDNS nameservers
my @SERVERS = qw(8.8.8.8 208.67.222.222);

my %IPS = (
    'openhouse.sk' => '178.79.159.217',
    'zoznam.sk'    => '213.81.185.31',
    'nexar.sk'     => '217.67.30.192',
);

for my $server (@SERVERS)
{
    for my $host ( keys %IPS )
    {
        is( nsLookup( $server, $host ),
            $IPS{$host}, "Looking up $host via $server" );
    }
}

done_testing();
