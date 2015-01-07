#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

# Load module from repository not from system's @INC
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname( dirname abs_path $0) . '/lib';
use Local::Misc;

################
# bytesToMeg() #
################

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

##############
# nsLookup() #
##############

# Google and OpenDNS nameservers
my @SERVERS = qw(8.8.8.8 208.67.222.222);

my %IPS = (
    'ist.ac.at' => '193.170.138.156',
    'zoznam.sk' => '213.81.185.31',
    'nexar.sk'  => '217.67.30.192',
);

for my $server (@SERVERS) {
    for my $host ( keys %IPS ) {
        is( nsLookup( $server, $host ),
            $IPS{$host}, "Looking up $host via $server" );
    }
}

done_testing();
