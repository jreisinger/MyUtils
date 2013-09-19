package Local::OS;

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
  sendMail
  getLongRunningProcs
  nsLookup
);

#--------------------------------------
# Modules

# Standard modules
use Sys::Hostname qw(hostname);

# CPAN modules
use Email::MIME;
use Email::Sender::Simple;
use Proc::ProcessTable;

#--------------------------------------
# Subroutines

sub bytesToMeg
{
    my $size = shift;
    return sprintf "%.2f", $size / ( 1024 * 1024 );
}

sub sendMail
{
    my ( $receiver, $subject, $mail_body ) = @_;

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


sub getLongRunningProcs
{
    my ( $user, $max_time ) = @_;

    my $long_running_procs;

    # Convert username to UID
    my $uid = getpwnam($user);

    # Dump all the information in the current process table
    my $t = new Proc::ProcessTable;
    foreach my $p ( @{ $t->table } )
    {
        # Skip uninteresting users
        next unless $p->uid == $uid;

        # For how long is the process running?
        my $current_time = time;                       # seconds since the epoch
        my $start_time   = $p->start;
        my $run_time     = $current_time - $start_time;

        if ( $run_time > $max_time )
        {
            push @$long_running_procs, $p->pid;
        }

    }

    return $long_running_procs;                        # aref
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

Local::OS - My Perl subroutines useful for systems administration

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

use Local::OS qw(<function1> <function2>);

=head1 FUNCTIONS

=over

=item bytesToMeg( $bytes )

Return MB in X.XX format.

=item sendMail( $to, $subject, $body )

Send email. Based on L<http://perldoc.perl.org/perlfaq9.html>.

=item getLongRunningProcs( $user, $seconds )

Return arrray reference with PIDs of $user's processes running for more than $seconds.

=item nsLookup( $nameserver, $host )

Return the IP address of a $host.

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


