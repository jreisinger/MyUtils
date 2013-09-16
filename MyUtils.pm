package MyUtils;

########################
# Pragmas
use v5.10.0;
use strict;
use warnings;

# UTF-8 for everything
use utf8;
use warnings qw( FATAL utf8 );
use open qw( :encoding(UTF-8) :std );
########################

=head1 MyUtils

MyUtils - useful Perl subroutines

    perl -I/home/jreisinger/perl5lib -M'MyUtils(nsLookup)' -E 'say nsLookup("8.8.8.8", "openhouse.sk")'

=head1 VERSION

Version 0.01

=cut

our $VERSION = v0.0.1;

########################
# Exports
use Exporter qw(import);
our @EXPORT_OK = qw(
  nsLookup
);
########################

########################
# Modules

# Standard modules
#use List::Util;
#use Scalar::Util;

# CPAN modules
#use List::MoreUtils;
########################

########################
# Configuration Parameters
########################

########################
# Subroutines

=head2 nsLookup

This function returns the IP address of a host.

    my $ip = nsLookup('8.8.8.8', 'openhouse.sk');

=cut

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

########################

=head1 AUTHOR

Jozef 'j0se' Reisinger, C<< <jozef.reisinger at gmail.com> >>

Inspired by

=over 4

=item * http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html

=item * http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse

=item * "The Otter Book" by David N. Blank-Edelman

=back

=cut

1;
