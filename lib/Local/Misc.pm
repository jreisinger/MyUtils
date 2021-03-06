package Local::Misc;

=head1 NAME

Local::Misc - miscellaneous functions

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
  justMe
  getConfig
  scaleIt
  sendMail
  getLongRunningProcs
  nsLookup
);

#--------------------------------------
# Modules

# Standard modules
use Sys::Hostname qw(hostname);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use Fcntl qw(:flock);

# CPAN modules

# My modules
use lib dirname( dirname abs_path $0) . '/lib';
use Local::Help;

#--------------------------------------
# Subroutines

=head1 FUNCTIONS

=head2 justMe()

Make sure only one instance of the program is running at a time. We do this by
opening the lockfile on the program itself. For more see:
http://perltricks.com/article/2/2015/11/4/Run-only-one-instance-of-a-program-at-a-time

=cut

sub justMe {

    # NOTE: '<' avoids truncating the source code of the program running this code
    open our $Lock, '<', $0 or die "Can't lock myself $0: $!";

    flock $Lock, LOCK_EX | LOCK_NB
      or die "Another instance of $0 is already running. Exiting ...\n";
}

=head2 getConfig( $file )

Parse simple VAR=VALUE configuration file and return a hashref containing the
configuration data. Comments and empty lines are allowed in the configuration
file.

Stolen from Perl Cookbook, 8.16.

=cut

sub getConfig {
    my $file = shift;

    my %config;

    open my $fh, '<', $file or die "Can't open $file: $!\n";
    while (<$fh>) {
        chomp;       # no newline
        s/#.*//;     # no comments
        s/^\s+//;    # no leading white
        s/\s+$//;    # no trailing white
        next unless length;    # anything left?
        my ( $var, $value ) = split( /\s*=\s*/, $_, 2 );
        $config{$var} = $value;
    }
    close $fh;

    return \%config;
}

=head2 scaleIt( $bytes )

Make sizes human readable

=cut

sub scaleIt {
    my $size_in_bytes = shift;

    return unless defined $size_in_bytes;

    my ( $size, $n ) = ( $size_in_bytes, 0 );
    ++$n and $size /= 1024 until $size < 1024;
    return sprintf "%.0f%s", $size, (qw[ B KB MB GB TB ])[$n];
}

=head2 sendMail( $to, $subject, $body )

Send email. Based on L<http://perldoc.perl.org/perlfaq9.html>.

=cut

sub sendMail {
    my ( $receiver, $subject, $mail_body ) = @_;

    # We need these modules
    my @modules = qw( Email::MIME Email::Sender::Simple );
    for (@modules) {
        loadModule($_) or die;
    }

    # sender will the user running the program
    my $host  = hostname;
    my $login = getlogin || getpwuid($<) || "uknown";
    my $from  = "$login\@$host";

    # first, create your message
    my $message = Email::MIME->create(
        header_str => [
            From    => $from,
            To      => $receiver,
            Subject => $subject,
        ],
        attributes => {
            encoding => 'quoted-printable',
            charset  => 'utf-8',
        },
        body_str => $mail_body,
    );

    # send the message
    use Email::Sender::Simple qw(sendmail);
    sendmail($message);
}

=head2 getLongRunningProcs( $user, $seconds )

Return arrray reference with PIDs of $user's processes running for more than $seconds.

=cut

sub getLongRunningProcs {
    my ( $user, $max_time ) = @_;

    # We need this module
    loadModule('Proc::ProcessTable') or die;

    my $long_running_procs;

    # Convert username to UID
    my $uid = getpwnam($user);

    # Dump all the information in the current process table
    my $t = new Proc::ProcessTable;
    foreach my $p ( @{ $t->table } ) {

        # Skip uninteresting users
        next unless $p->uid == $uid;

        # For how long is the process running?
        my $current_time = time;                       # seconds since the epoch
        my $start_time   = $p->start;
        my $run_time     = $current_time - $start_time;

        if ( $run_time > $max_time ) {
            push @$long_running_procs, $p->pid;
        }

    }

    return $long_running_procs;                        # aref
}

=head2 nsLookup( $nameserver, $host )

Return the IP address of a $host.

=cut

sub nsLookup {
    my ( $srv, $host ) = @_;
    my $nslookupexe = '/usr/bin/nslookup';

    return unless -e $nslookupexe;

    open my $NSLOOKUP, '-|', "$nslookupexe $host $srv" or die "$!";
    while (<$NSLOOKUP>) {
        next unless /^Address/;
        next if /#/;    # skip DNS server address
        s/^Address[^\d]+//;
        chomp;
        return $_;
    }
    close $NSLOOKUP;
}

1;
