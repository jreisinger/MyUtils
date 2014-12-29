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
our @EXPORT = qw(
  listNetServices
);

#--------------------------------------
# Modules

# Standard modules
use File::stat;

# CPAN modules
use local::lib;
use Nmap::Parser;

#--------------------------------------
# Subroutines

sub isSafe {
    my $path = shift;
    my $info = stat($path);
    return unless $info;

    # owner neither superuser nor me
    # the real uid is stored in the $< variable
    if ( ( $info->uid != 0 ) && ( $info->uid != $< ) ) {
        return 0;
    }

    # check whether group or other can write file.
    # use 066 to detect either reading or writing
    if ( $info->mode & 022 ) {

        # someone else can write this
        return 0 unless -d _;    # non-directories aren't safe

        # but directories with the sticky bit (01000) are
        return 0 unless $info->mode & 01000;
    }
    return 1;
}

sub listNetServices {
    my @hosts = @_;

    my $services;                # HoH

    # Anonymous subroutine
    my $nmap = sub {
        my $host = shift;        #Nmap::Parser::Host object, just parsed

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

Local::Sec - security related subroutines

=head1 FUNCTIONS

=over

=item isSafe( $file )

If the file is writable by someone other than the owner or is owned by someone
other than the current user or the superuser, it shouldn't be trusted. To
figure out file ownership and permissions, the C<stat()> function is used.

Return true (1) if $file is deemed safe false (0) otherwise. Return C<undef> if
C<stat()> fails.

Taken from I<Perl Cookbook>, recipe 8.17.

=item listNetServices( @hosts )

Are we running different versions of network services (ex. SSH) on different
hosts? Useful for identifying unpatched (old) versions of network services but
we have to include a host with patched services into @hosts.

=back

=head1 AUTHOR

Jozef 'j0se' Reisinger, C<< <jozef.reisinger at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut


