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

    my $services; # HoH

    # Anonymous subroutine
    my $nmap = sub {
        my $host = shift;    #Nmap::Parser::Host object, just parsed

        for my $port ( $host->tcp_ports('open') ) {

            # Nmap::Parser::Host::Service object
            my $svc = $host->tcp_service($port);

            my $service = join( ' | ',
                $svc->name    // '',
                $svc->product // '',
                $svc->version // '' );

            push @{ $services->{$port}{$service} },
              $host->hostname . ' (' . $host->addr . ')';

        }
    };

    my $np = new Nmap::Parser;
    $np->callback($nmap);
    $np->parsescan( '/usr/bin/nmap', '-sV', @hosts );

    #use Data::Dumper;
    #print Dumper \$services;

    # Print report
    for my $port ( sort keys %$services ) {

        my $n_versions = keys %{ $services->{$port} };
        next unless $n_versions > 1;

        print "$port - $n_versions different versions on this port\n";

        for my $version ( sort keys %{ $services->{$port} } ) {
            print ' ' x 4 . $version . "\n";
            for my $host ( sort @{ $services->{$port}{$version} } ) {
                print ' ' x 8 . $host . "\n";
            }
        }
    }

    return;
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

Are we running different versions of network services (ex. SSH) on different
hosts? Useful for identifying unpatched (old) versions of network services but
we have to include a host with patched services into @hosts.

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


