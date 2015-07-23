package Local::MyUtils;

use 5.006;
use strict;
use warnings;

=head1 NAME

Local::MyUtils - functions that I find useful (mostly) for systems administration

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

List available functions:

 $ ./bin/list-functions

Copy/paste the function(s) into your script.

=head1 DESCRIPTION

Some Perl functions that I find useful (mostly) for systems administration.
I've developed and tested them on Debian, so far.

See also my [bin](https://github.com/jreisinger/dotfiles/tree/master/bin) directory and the [sys](https://github.com/jreisinger/sys) repo.

=head1 USAGE

1) The easiest way is to copy/paste the function(s) into your script. That's basically it.

For the following two ways you will need to install the software - see *Installation* below.

2) Use from command line

    perl -MLocal::Misc -le 'print scaleIt(3789876)'

In case you use the function often, create a bash function in `~/.profile` for
it:

    function scaleit () {
        perl -MLocal::Misc -le "print scaleIt($1)"
    }

After logging out/logging in or sourcing C<~/.profile>, you can call it like
C<scaleit> from bash.

3) Use as a module from inside your program

    use local::lib;  # in case you are using local::lib
    use Local::<ModuleName>;

=head1 INSTALLATION

 cd ~/perl5 && git clone git@github.com:jreisinger/MyUtils.git
 echo 'PERL5LIB=$HOME/perl5/MyUtils/lib:$PERL5LIB; export PERL5LIB;' >> ~/.profile

Now you should logout/login or `source ~/.profile`.

 cd $HOME/perl5/MyUtils && prove -l

=head1 Documentation

Functions are grouped via modules. Module name reflects the area in which the
 function(s) might be useful. To list functions contained in a module:

     ~/perl5/MyUtils/bin/list-functions

To get documentation for a certain module (i.e. group of functions):

     perldoc Local::<ModuleName>

To list available modules (if you have completion working):

     perldoc Local::<TAB>

=head1 SOURCE REPOSITORY

L<http://github.com/jreisinger/MyUtils>

=head1 AUTHOR

Jozef Reisinger, E<lt>reisinge@cpan.orgE<gt>

=head1 Inspired by or copied from :-)

L<http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html>

L<http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse>

"The Otter Book" by David N. Blank-Edelman

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Jozef Reisinger.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

1;