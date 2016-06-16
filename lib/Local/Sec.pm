package Local::Sec;

=head1 NAME

Local::Sec - security related functions

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
  listNetServices
);

#--------------------------------------
# Modules

# Standard modules
use File::stat;
use Cwd;
use POSIX qw(sysconf _PC_CHOWN_RESTRICTED);

# CPAN modules
use local::lib;
use Nmap::Parser;

#--------------------------------------
# Subroutines

=head1 FUNCTIONS

=head2 isSafe( $file )

Return true (1) if $file is deemed safe false (0) otherwise. Return C<undef> if
C<stat()> fails.

If the file is writable by someone other than the owner or is owned by someone
other than the current user or the superuser, it's not safe and shouldn't be
trusted. To figure out file ownership and permissions, the C<stat()> function
is used.

Taken from I<Perl Cookbook>, recipe 8.17.

=cut

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
    # (use 066 to detect either reading or writing)
    # see https://en.wikipedia.org/wiki/Bitwise_operation#AND
    if ( $info->mode & 022 ) {    # someone else can write this

        # non-directories aren't safe
        return 0 unless -d _;

        # but directories with the sticky bit (01000) are
        return 0 unless $info->mode & 01000;
    }
    return 1;
}

=head2 isVerySafe( $file )

Also ensure that enclosing directory is not writable. This is a problem on
systems that allow users to make a file owned by someone else ("chown
giveaway").

=cut

sub isVerySafe {
    my $path = shift;

    # we don't have "chown giveaway" problem
    return isSafe($path) if sysconf(_PC_CHOWN_RESTRICTED);

    $path = getcwd() . "/" . $path if $path !~ m{^/};
    do {
        return unless is_safe($path);
        $path =~ s#([^/]+|/)$##;

        # dirname
        $path =~ s#/$## if length($path) > 1;    # last slash
    } while length $path;

    return 1;
}

=head2 listNetServices( @hosts )

Are we running different versions of network services (ex. SSH) on different
hosts? Useful for identifying unpatched (old) versions of network services but
we have to include a host with patched services into @hosts.

=cut

sub listNetServices {
    my @hosts = @_;

    my $services;    # HoH

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
