package Local::Sec;

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
  listNetServices
);

#--------------------------------------
# Modules

# Standard modules

# CPAN modules
use local::lib;
use Nmap::Parser;

#--------------------------------------
# Subroutines

sub listNetServices {
    my @hosts = @_;

    my $services;

    my $nmap = sub {
        my $host = shift;    #Nmap::Parser::Host object, just parsed
        print $host->hostname, ' (', $host->addr, ')',
          " has these ports open:\n";

        for my $port ( $host->tcp_ports('open') ) {

            # Nmap::Parser::Host::Service object
            my $svc = $host->tcp_service($port);

            my $service =
              join( ' | ', $svc->name, $svc->product, $svc->version );

            push @{ $services->{$port}{$service} }, $host->hostname;

        }
    };

    my $np = new Nmap::Parser;
    $np->callback( $nmap );
    $np->parsescan( '/usr/bin/nmap', '-sV', @hosts );

    use Data::Dumper;
    print Dumper \$services;
}

1;

__END__

=head1 NAME

Local::Sec - My security related Perl subroutines

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

use Local::Sec qw(<function1> <function2>);

=head1 FUNCTIONS

=over

=item listNetServices( @hosts )

Are we running different versions of network services?

=back

=head1 AUTHOR

Jozef 'j0se' Reisinger, C<< <jozef.reisinger at gmail.com> >>

Inspired by (or copied from :-)):

=over 4

=item *
L<http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html>

=item * L<http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse>

=item * "The Otter Book" by David N. Blank-Edelman

=back

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut


