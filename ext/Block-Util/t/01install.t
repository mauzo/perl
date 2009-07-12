#!usr/bin/perl

BEGIN {
    if ($ENV{PERL_CORE}) {
        chdir "t" if -d "t";
        @INC = "../lib";
    }
}

use warnings;
use strict;

use Test::More tests => 2;
use Block::Util qw/install_block/;

my $got;

sub ib {
    my ($block, $n) = @_;
    install_block "\U$block", sub { $got .= ":$block$n" };
}

{
    BEGIN { $got .= ":begin1" }

    {
        BEGIN { ib scopecheck => 1 }
        BEGIN { ib scopecheck => 2 }

        BEGIN { $got .= ":begin2"  }

        {
            BEGIN { ib scopecheck => 3 }
        }

        BEGIN { $got .= ":begin3" }
    }

    BEGIN { $got .= ":begin4" }
}

is $got, 
    ":begin1:begin2:scopecheck3:begin3:scopecheck2:scopecheck1:begin4",
    "SCOPECHECK blocks";

$got = "";

{
    $got .= ":runtime1";

    {
        BEGIN { ib leave => 1 }
        BEGIN { ib leave => 2 }

        $got .= ":runtime2";

        BEGIN { ib enter => 1 }
        BEGIN { ib enter => 2 }
    }

    $got .= ":runtime3";
}

is $got,
    ":runtime1:enter1:enter2:runtime2:leave2:leave1:runtime3",
    "run-time scope blocks";
