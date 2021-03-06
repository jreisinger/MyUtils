package Local::Net;

=head1 NAME

Local::Net - networking related functions

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
  searchLDAP
);

#--------------------------------------
# Modules

# Standard modules
use Carp;

# CPAN modules
use Net::LDAP;
use Net::LDAP::LDIF;

#--------------------------------------
# Subroutines

=head1 FUNCTIONS

=head2 _getCredentials( )

Ask binddn and password from the user and return it. Password won't be
shown while typed in.

=cut

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

=head2 searchLDAP( { server => $server, filter => $filter, attrs => [ @attributes ] } )

Search LDAP $server and print @attributes of entries satisfying the $filter. Ex.:
    searchLDAP( {
        server => "ldap.example.com",
        filter => "(&(objectClass=organizationalPerson)(cn=Doe John))",
        attrs  => [ qw( cn sn l mail ) ]
    } )

=cut

sub searchLDAP {
    my $args   = shift;
    my $server = $args->{server};
    my $filter = $args->{filter};
    my $attrs  = $args->{attrs};

    croak "Not enough arguments for searchLDAP()" unless keys %$args == 3;

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
