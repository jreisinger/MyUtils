package MyUtils;

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
our @EXPORT_OK = qw(
  bytesToMeg
  nsLookup
);

#--------------------------------------
# Modules

# Standard modules
#use List::Util;
#use Scalar::Util;

# CPAN modules
#use List::MoreUtils;

#--------------------------------------
# Subroutines

sub bytesToMeg
{
    my $size = shift;
    return sprintf "%.2f", $size / ( 1024 * 1024 );
}

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
__END__

=head1 NAME

MyUtils - Perl subroutines useful for systems administration

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    # Installation
    cd && git clone https://github.com/jreisinger/perl5lib

    # Usage from inside a program
    use lib $ENV{HOME} . '/perl5lib';
    use MyUtils qw(bytesToMeg);

    # Usage from command line
    perl -I/home/jreisinger/perl5lib -M'MyUtils(bytesToMeg)' -E 'say bytesToMeg(3789876) . "MB"'

=head1 DESCRIPTIONS

The following functions are provided:

=over

=item bytesToMeg( $bytes )

Convert bytes to X.XXMB.

=item nsLookup( $nameserver, $host )

Returns the IP address of a $host.

=back

=head1 AUTHOR

Jozef 'j0se' Reisinger, C<< <jozef.reisinger at gmail.com> >>

Inspired by (or copied from :-)):

=over 4

=item * http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html

=item * http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse

=item * "The Otter Book" by David N. Blank-Edelman

=back

=cut


