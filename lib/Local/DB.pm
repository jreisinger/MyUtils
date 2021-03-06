package Local::DB;

=head1 NAME

Local::DB - functions useful for database administration

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
  listMysqlStruct
);

#--------------------------------------
# Modules

# Standard modules

# CPAN modules
use DBI;

#--------------------------------------
# Subroutines

=head1 FUNCTIONS

=head2 _getCredentials( )

Ask username and password from the user and return it. Password won't be
shown while typed in.

=cut

sub _getCredentials {

    print 'Enter username: ';
    chomp( my $user = <STDIN> );

    system 'stty -echo';
    print "Enter passwd for $user: ";
    chomp( my $pw = <STDIN> );
    system 'stty echo';
    print "\n";

    return $user, $pw;
}

=head2 listMysqlStruct( { host => $host, file => $file } )

List all databases and their basic table structures on a MySQL server. If $host
is not defined it defaults to 'localhost', if file is not defined output goes
to STDOUT.

=cut

sub listMysqlStruct {
    my $args = shift;
    my $host = $args->{host} // 'localhost';
    my $file = $args->{file} // undef;

    my ( $user, $pw ) = _getCredentials();

    my $start = 'information_schema';    # connect initially to this database

    # connect to the start MySQL database
    my $dbh =
      DBI->connect( "DBI:mysql:$start", $user, $pw,
        { RaiseError => 1, PrintError => 1, ShowErrorStatement => 1 } );

    # find the databases on the server
    my $sth = $dbh->prepare(q{SHOW DATABASES});
    $sth->execute;
    my @dbs = ();
    while ( my $aref = $sth->fetchrow_arrayref ) {
        push( @dbs, $aref->[0] );
    }

    my $fh;
    if ($file) {
        open $fh, '>', $file or die "$!";
        select $fh;
    }

    # find the tables in each database
    foreach my $db (@dbs) {
        print "---$db---\n";
        $sth = $dbh->prepare(qq{SHOW TABLES FROM $db});
        $sth->execute;
        my @tables = ();
        while ( my $aref = $sth->fetchrow_arrayref ) {
            push( @tables, $aref->[0] );
        }

        # find the column info for each table
        foreach my $table (@tables) {
            print "\t$table\n";
            $sth = $dbh->prepare(qq{SHOW COLUMNS FROM $table FROM $db});
            $sth->execute;
            while ( my $aref = $sth->fetchrow_arrayref ) {
                print "\t\t", $aref->[0], ' [', $aref->[1], "]\n";
            }
        }
    }

    close $fh if $fh;
    select STDOUT;

    $dbh->disconnect;
}

1;
