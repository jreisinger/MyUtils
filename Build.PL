use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Local::MyUtils',
    license            => 'artistic_2',
    dist_author        => q{Jozef Reisinger <reisinge@cpan.org>},
    dist_version_from  => 'lib/Local/MyUtils.pm',
    release_status     => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Test::More'            => 0,
        'Email::MIME'           => 0,
        'Email::Sender::Simple' => 0,
    },
    add_to_cleanup     => ['Local-MyUtils-*'],
    create_makefile_pl => 'traditional',
    meta_merge         => {
        resources => {
            repository => "http://github.com/jreisinger/MyUtils",
            bugtracker => "http://github.com/jreisinger/MyUtils/issues",
        },
        no_index => { file => ['README.pod'], },
    }
);

$builder->create_build_script();
