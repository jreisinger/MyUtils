#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

# Load module from repository not from system's @INC
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname( dirname abs_path $0) . '/lib';

BEGIN {
    use_ok 'Local::Help' || print "Bail out!\n";
}

ok( loadModule('File::Spec'),   "Core module loaded (File::Spec)" );
ok( loadModule('File/Spec.pm'), "Core module loaded (File/Spec.pm)" );
ok( not( loadModule('Non::Existent::Module') ),
    "Not existent module not loaded" );

done_testing();
