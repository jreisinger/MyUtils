MyUtils
=======

Some Perl functions that I find useful.

* Installation

    cd && git clone https://github.com/jreisinger/MyUtils

* Testing (optional)

    prove -r $HOME/MyUtils/t

* Adding to @INC (list of Perl library directories)

    export PERL5LIB="$PERL5LIB:$HOME/MyUtils"     # can go into ~/.profile

* Documentation

    perldoc Local::<ModuleName>

* Usage from inside a program

    use Local::<ModuleName> qw(<function1Name> [<function2Name>]);

* Usage from command line

    perl -I$HOME/MyUtils -M'Local:OS(bytesToMeg)' -E 'say bytesToMeg(3789876) . "MB"'
