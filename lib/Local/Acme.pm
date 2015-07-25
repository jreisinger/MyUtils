package Local::Acme;

=head1 NAME

Local::Acme - funny functions

=cut

#--------------------------------------
# Pragmas
use v5.10.0;
use strict;
use warnings;

# UTF-8 for everything
use utf8;
use warnings qw( FATAL utf8 );
use open qw( :encoding(UTF-8) :std );

our $VERSION = v0.0.1;

#--------------------------------------
# Exports
use Exporter qw(import);
our @EXPORT = qw(
  unpack_hal
);

#--------------------------------------
# Modules

# Standard modules

# CPAN modules

# My modules

#--------------------------------------
# Subroutines

=head1 FUNCTIONS

=head2 unpack_hal

Convert from "HAL" to "IBM" using pack and unpack functions to covert between
characters and values.

Taken from Perl Cookbook, 1.4.

=cut

sub unpack_hal {
    my $hal = "HAL";

    # Convert to 8-bit bytes; use U* format for Unicode
    my @bytes = unpack( "C*", $hal );    # bytes values 72 65 76

    for my $val (@bytes) {
        $val++;                          # add 1 to each byte value
    }

    # Converto from (8-bit bytes) to characters
    my $ibm = pack( "C*", @bytes );

    return $ibm;
}

1;
