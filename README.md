MyUtils
=======

Some Perl functions (subroutines) that I find useful for systems
administration. I've developed and tested them on Debian, so far.

Installation
------------

    cpanm local::lib
    echo 'PERL5LIB=$HOME/perl5/MyUtils/lib:$PERL5LIB; export PERL5LIB;' >> ~/.profile
    perl -I$HOME/perl5/lib/perl5/ -Mlocal::lib >> ~/.profile

Now you should logout/login or `source ~/.profile`.

    cd ~/perl5 && git clone git@github.com:jreisinger/MyUtils.git

Testing
-------

    cd $HOME/perl5/MyUtils && prove -l

Documentation
-------------

Functions are grouped via modules. Module name reflects the area in which the
function(s) might be useful. To get documentation for a certain module (i.e.
group of functions):

    perldoc Local::<ModuleName>

To list available modules (if you have completion working):

    perldoc Local::<TAB>

Usage
-----

1) Use from command line

    perl -MLocal::Misc -le 'print scaleIt(3789876)'

In case you use the function often, create a bash function in `~/.profile` for
it:

    function scaleit () {
        perl -MLocal::Misc -le "print scaleIt($1)"
    }

After logging out/logging in or sourcing `~/.profile`, you can call it like
`scaleit` from bash.

2) Use as a module from inside your program

    use local::lib;  # in case you are using local::lib
    use Local::<ModuleName>;

3) Copy/paste the function(s) into your script. You might need to `use` some
modules (see "Modules" section of the corresponding module in
`~/bin/perl5/MyUtils/lib/<Module>.pm` if not sure which ones).

Inspired by or copied from :-)
------------------------------

* http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html
* http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse
* "The Otter Book" by David N. Blank-Edelman
