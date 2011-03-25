#!/usr/bin/env perl

use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
    build_requires => {
        'Test::More'  => 0,
        'Plack::Test' => 0,
    },
    module_name    => 'Plack::Middleware::Options',
    license        => 'perl',
    requires       => {
        'Plack::Middleware' => 0,
    },
);
$build->create_build_script;
