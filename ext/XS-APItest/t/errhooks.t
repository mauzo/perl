#!/usr/bin/perl

use warnings;
use strict;

use Test::More;
use XS::APItest;

our $thrown;
BEGIN { *thrown = \$XS::APItest::thrown }

ok !defined $thrown,        "\$thrown undefined before eval";

eval {
    is $thrown, "",         "\$thrown false inside eval";
};

ok !defined $thrown,        "\$thrown undefined after eval";

my $inD;
{
    package Destruct;

    sub DESTROY {
        $inD = $XS::APItest::thrown;
    }
}

eval {
    my $x = bless [], "Destruct";
};
ok !$inD,                   "\$thrown false in normal DESTROY";

eval {
    my $x = bless [], "Destruct";
    die "foo";
};
ok $inD,                    "\$thrown true in exceptional DESTROY";

done_testing;
