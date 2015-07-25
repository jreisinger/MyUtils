#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

# Load module from repository not from system's @INC
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname( dirname abs_path $0) . '/lib';
use Local::Acme;

################
# unpack_hal() #
################

is(unpack_hal(), "IBM", "HAL unpacks to IBM");

done_testing();
