package Local::Util;

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
  loadModule
);

#--------------------------------------
# Modules

# Standard modules
use File::Spec;

#--------------------------------------
# Subroutines

sub loadModule {
    my $module = shift;

    # require doesn't work with Module::Name stored in a variable so we turn it
    # into Module/Name.pm
    $module = File::Spec->catfile( split( /::/, $module ) ) . '.pm'
      if $module =~ /::/;

    eval {
        require $module;
        $module->import;
        1;
    };

    if ($@) {

        #print STDERR "Failed to load $module because: $@";
        return 0;
    } else {
        return 1;
    }
}

=head1 NAME

Local::Util - helper functions

=head1 SYNOPSIS

use Local::Util;

=head1 FUNCTIONS

=over

=item loadModule( $module )

Try to load a $module at runtime. Return 1 on success 0 otherwise. $module can
be 'Module::Name' or 'Module/Name.pm'.

Loading error is stored in C<$@> and can propagate to die() if die() is
use without arguments:

    loadModule( $module ) or die;

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

