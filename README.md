MyUtils
=======

Some Perl functions that I find useful.

Installation
------------

    cpanm local::lib
    echo 'PERL5LIB=$HOME/perl5/MyUtils/lib:$PERL5LIB' >> ~/.profile
    perl -I$HOME/perl5/lib/perl5/ -Mlocal::lib >> ~/.profile

Now you should logout/login or `source ~/.profile`

    cd ~/perl5 && git clone https://github.com/jreisinger/MyUtils

Testing
-------

    cd $HOME/perl5/MyUtils && prove -l

Documentation
-------------

    perldoc Local::<ModuleName>
    
To list available modules

    perldoc Local::<TAB>

Usage
-----

From inside a program

    use local::lib;  # in case you are using local::lib
    use Local::<ModuleName> qw(<function1Name> [<function2Name>]);

From command line

    perl -M'Local::OS(bytesToMeg)' -E 'say bytesToMeg(3789876) . "MB"'
