package Local::Net;

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
  searchLDAP
);

#--------------------------------------
# Modules

# Standard modules

# CPAN modules
use Net::LDAP;
use Net::LDAP::LDIF;

#--------------------------------------
# Subroutines

sub _getCredentials {

    print 'Enter binddn (ex. uid=bucky,ou=people,dc=example,dc=edu): ';
    chomp( my $user = <STDIN> );

    system 'stty -echo';
    print "Enter passwd for '$user': ";
    chomp( my $pw = <STDIN> );
    system 'stty echo';
    print "\n";

    return $user, $pw;
}

sub searchLDAP {
    my $args   = shift;
    my $server = $args->{server};
    my $filter = $args->{filter};
    my $attrs  = $args->{attrs};

    my $port = getservbyname( 'ldap', 'tcp' ) || '389';

    my ( $binddn, $passwd ) = _getCredentials();
    my ($basedn) = $binddn =~ /(dc=[^,]+,dc=.+)$/;    # this looks fishy
    my $scope = "sub";                                # default

    # create a Net::LDAP object and connect to server
    my $c = Net::LDAP->new( $server, port => $port )
      or die "Unable to connect to $server: $@\n";

    # use no parameters to bind() for anonymous bind
    my $mesg = $c->bind( $binddn, password => $passwd );
    if ( $mesg->code ) {
        die 'Unable to bind: ' . $mesg->error . "\n";
    }

    my $searchobj = $c->search(
        base   => $basedn,
        scope  => $scope,
        filter => $filter,
        attrs  => $attrs,
    );
    die 'Bad search: ' . $searchobj->error() if $searchobj->code();

    # print the return values from search() found in our $searchobj
    if ($searchobj) {
        my $ldif = Net::LDAP::LDIF->new( '-', 'w' );
        $ldif->write_entry( $searchobj->entries() );
        $ldif->done();
    }

    $c->unbind();    # not strictly necessary, but polite
}

1;
__END__

=head1 NAME

Local::Net - My networking related Perl subroutines

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

use Local::OS qw(<function1> <function2>);

=head1 FUNCTIONS

=over

=item searchLDAP( { server => $server, filter => $filter, attrs => [
@attributes ] } )

Search LDAP $server and print @attributes of entries satisfying the $filter.
Ex. searchLDAP( { server => "ldap.example.com", filter =>
"(&(objectClass=organizationalPerson)(cn=Doe John))", attrs => [ qw( cn sn l
mail ) ] } )

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


