#   Title   : MyUtils
#   Purpose : Some useful subroutines
#   Source  : http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html, http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse
#

# --------------------------------------
# Package
package MyUtils;

# --------------------------------------
# Pragmatics

use v5.10.0;

use strict;
use warnings;

# UTF-8 for everything
use utf8;
use warnings qw( FATAL utf8 );
use open qw( :encoding(UTF-8) :std );

# --------------------------------------
# Version
our $VERSION = v1.0.0;

# --------------------------------------
# Exports
use Exporter qw(import);
our @EXPORT_OK = qw(
  nsLookup
);

# --------------------------------------
# Modules

# Standard modules
#use List::Util;
#use Scalar::Util;

# CPAN modules
#use List::MoreUtils;

# --------------------------------------
# Configuration Parameters

# --------------------------------------
# Subroutines

sub nsLookup
{
    my ( $srv, $host ) = @_;
    my $nslookupexe = '/usr/bin/nslookup';

    open my $NSLOOKUP, '-|', "$nslookupexe $host $srv" or die "$!";
    while (<$NSLOOKUP>)
    {
        next unless /^Address/;
        next if /#/;    # skip DNS server address
        s/^Address[^\d]+//;
        chomp;
        return $_;
    }
    close $NSLOOKUP;
}

1;
