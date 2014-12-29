MyUtils
=======

Some Perl functions that I find useful.

Installation
------------

    cpanm local::lib
    echo 'PERL5LIB=$HOME/perl5/MyUtils/lib:$PERL5LIB' >> ~/.profile
    perl -I$HOME/perl5/lib/perl5/ -Mlocal::lib >> ~/.profile

Now you should logout/login or `source ~/.profile`.

    cd ~/perl5 && git clone git@github.com:jreisinger/MyUtils.git

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
    use Local::<ModuleName>;

From command line

    perl -MLocal::OS -wE 'say bytesToMeg(3789876) . "MB"'


Inspired by or copied from :-)
------------------------------

* http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html

* http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse

* "The Otter Book" by David N. Blank-Edelman
