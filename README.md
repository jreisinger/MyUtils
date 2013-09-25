MyUtils
=======

Some Perl functions that I find useful.

Installation

    cpanm --sudo local::lib  # or see https://metacpan.org/module/local::lib#The-bootstrapping-technique
    echo 'PERL5LIB=$HOME/perl5/MyUtils/lib:$PERL5LIB' >> ~/.profile
    perl -I$HOME/perl5/lib/perl5/ -Mlocal::lib >> ~/.profile
    ## You should login/logout now or source ~/.profile
    cd ~/perl5 && git clone https://github.com/jreisinger/MyUtils
    cpanm Email::MIME Email::Sender::Simple Proc::ProcessTable DBI Nmap::Parser

Testing (optional)

    prove -r $HOME/perl5/MyUtils/t

Documentation

    perldoc Local::<ModuleName>

Usage from inside a program

    use local::lib;  # in case you are using local::lib
    use Local::<ModuleName> qw(<function1Name> [<function2Name>]);

Usage from command line

    perl -M'Local::OS(bytesToMeg)' -E 'say bytesToMeg(3789876) . "MB"'
