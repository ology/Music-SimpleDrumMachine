#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use_ok 'Music::SimpleDrumMachine';

new_ok 'Music::SimpleDrumMachine';

my $obj = new_ok 'Music::SimpleDrumMachine' => [
    verbose => 1,
];

is $obj->verbose, 1, 'verbose';

done_testing();
