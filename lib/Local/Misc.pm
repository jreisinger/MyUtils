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
  bytesToMeg
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

# CPAN modules

# My modules
use lib dirname( dirname abs_path $0) . '/lib';
use Local::Help;

#--------------------------------------
# Subroutines

=head1 FUNCTIONS

=head2 bytesToMeg( $bytes )

Return MB in X.XX format.

=cut

sub bytesToMeg {
    my $size = shift;
    return sprintf "%.2f", $size / ( 1024 * 1024 );
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

    open my $NSLOOKUP, '-|', "$nslookupexe $host $srv" or die "$!";
    while (<$NSLOOKUP>) {
        next unless /^Address/;
        next if /#/;                                   # skip DNS server address
        s/^Address[^\d]+//;
        chomp;
        return $_;
    }
    close $NSLOOKUP;
}

1;

=head1 AUTHOR

Jozef 'j0se' Reisinger, C<< <jozef.reisinger at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
