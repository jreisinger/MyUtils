MyUtils
=======

Some Perl functions that I find useful (mostly) for systems administration.
I've developed and tested them on Debian, so far.

See also my [bin](https://github.com/jreisinger/dotfiles) directory and the [sys](https://github.com/jreisinger/sys) repo.

Usage
-----

1) The easiest way is to copy/paste the function(s) into your script. That's basically it.

For the following two ways you will need to install the software - see *Installation* below.

2) Use from command line

    perl -MLocal::Misc -le 'print scaleIt(3789876)'

In case you use the function often, create a bash function in `~/.profile` for
it:

    function scaleit () {
        perl -MLocal::Misc -le "print scaleIt($1)"
    }

After logging out/logging in or sourcing `~/.profile`, you can call it like
`scaleit` from bash.

3) Use as a module from inside your program

    use local::lib;  # in case you are using local::lib
    use Local::<ModuleName>;

Installation
------------

    cd ~/perl5 && git clone git@github.com:jreisinger/MyUtils.git
    echo 'PERL5LIB=$HOME/perl5/MyUtils/lib:$PERL5LIB; export PERL5LIB;' >> ~/.profile

Now you should logout/login or `source ~/.profile`.

    cd $HOME/perl5/MyUtils && prove -l

Documentation
-------------

Functions are grouped via modules. Module name reflects the area in which the
function(s) might be useful. To list functions contained in a module:

    ~/perl5/MyUtils/bin/list-functions

To get documentation for a certain module (i.e. group of functions):

    perldoc Local::<ModuleName>

To list available modules (if you have completion working):

    perldoc Local::<TAB>

Inspired by or copied from :-)
------------------------------

* http://lookatperl.blogspot.co.il/2013/07/a-look-at-my-utility-library.html
* http://perlmaven.com/how-to-create-a-perl-module-for-code-reuse
* "The Otter Book" by David N. Blank-Edelman
