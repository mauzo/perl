#!./perl

BEGIN {
    chdir "t" if -d "t";
    @INC = "../lib";
    require "./test.pl";
}

use strict;
use warnings;
use feature ":5.11";

plan tests => 15*3 + 27;

# avoid any confusion with lexicals
use vars qw/$want $got @want @got/;

my @warns;
BEGIN { $SIG{__WARN__} = sub { push @warns, $_[0] } }

{
    my @blocks = (
        [bare       => '{*}'                            ],
        [do         => 'do {*}'                         ],
        [while      => 'my $x; while (not $x++) {*}'    ],
        [foreach    => 'for (1) {*}'                    ],
        ["C for"    => 'for (my $x; !$x; $x++) {*}'     ],
        [continue   => 'for (1) {} continue {*}'        ],
        [if         => 'if (1) {*}'                     ],
        [else       => 'if (0) {} else {*}'             ],
        [elsif      => 'if (0) {} elsif (1) {*}'        ],
        [given      => 'given (1) {*}'                  ],
        [when       => 'given (1) { when (1) {*} }'     ],
        [default    => 'given (1) { default {*} }'      ],
        [try        => 'eval {*}'                       ],
        [eval       => 'eval q{*}'                      ],
        ["sub"      => 'no warnings "redefine"; sub foo {*} foo'],
    );

    for (@blocks) {
        my ($type, $block) = @$_;

        $got = "";
        $block =~ s'\{\*\}'{
            LEAVE { $got .= ":leave1" }
            ENTER { $got .= ":enter1" }
            SCOPECHECK { $got .= ":scopecheck1" }
            BEGIN { $got .= ":begin1" }
            $got .= ":run1";
        }';
        $block =~ s'$'; $got .= ":run2";';
        my $rv = eval "$block; 1;";

        ok $rv,             "$type block accepts scope blocks"
            or diag "\$\@: $@";
        is $got, ":begin1:scopecheck1:enter1:run1:leave1:run2",
                            "$type block runs scope blocks";

        $got = "";
        ($block = $_->[1]) =~ s'\{\*\}'{
            ENTER { $got .= ":enter1" }
            LEAVE { $got .= ":leave1" }
        }';
        eval $block;

        is $got, ":enter1:leave1", 
                            "empty $type block runs scope blocks";
    }
}

$got = "";
eval q{
    BEGIN { $got .= ":begin1" }

    {
        SCOPECHECK { $got .= ":scopecheck1" }
        BEGIN { $got .= ":begin2" }
    }

    BEGIN { $got .= ":begin3" }
};

is $got, ":begin1:begin2:scopecheck1:begin3", 
        "SCOPECHECK called at end of scope";

$got = "";

eval q{
    {
        SCOPECHECK { $got .= ":scopecheck1" }
        SCOPECHECK { $got .= ":scopecheck2" }
    }
};

is $got, ":scopecheck2:scopecheck1",
        "SCOPECHECK called in reverse order";

$got = "";
eval q{
    {
        SCOPECHECK { $got .= ":scopecheck1" }
        {
            SCOPECHECK { $got .= ":scopecheck2" }
        }
        SCOPECHECK { $got .= ":scopecheck3" }
    }
};

is $got, ":scopecheck2:scopecheck3:scopecheck1",
    "nested SCOPECHECKs";

$got = "";
{
    $got .= ":runtime1";
    {
        LEAVE { $got .= ":leave1" }
        $got .= ":runtime2";
        ENTER { $got .= ":enter1" }
    }
    $got .= ":runtime3";
}

is $got, ":runtime1:enter1:runtime2:leave1:runtime3",
    "ENTER and LEAVE called correctly";

$got = "";
{
    ENTER { $got .= ":enter1" }
    ENTER { $got .= ":enter2" }
}

is $got, ":enter1:enter2",
    "ENTER called in declared order";

$got = "";
{
    LEAVE { $got .= ":leave1" }
    LEAVE { $got .= ":leave2" }
}

is $got, ":leave2:leave1",
    "LEAVE called in reverse order";

sub ctx { 
    my $gimme = (caller 1)[5];
    defined $gimme ? $gimme ? "LIST" : "SCALAR" : "VOID";
}

sub doctx {
    ENTER { $got .= ":ENTER:" . ctx }
    LEAVE { $got .= ":LEAVE:" . ctx }
    qw/foo bar/;
}

sub doargs {
    ENTER { $got .= ":ENTER:@_" }
    LEAVE { $got .= ":LEAVE:@_" }
    qw/foo bar/;
}

{
    local ($", @_) = qw/: a b c/;
    no warnings "uninitialized";

    $got = "";
    doctx;
    is $got, ":ENTER:VOID:LEAVE:VOID",      "padblks in void ctx";

    $got = "";
    doargs qw/ONE TWO/;
    is $got, ":ENTER:ONE:TWO:LEAVE:bar",    "\@_ in void ctx";

    $got = "";
    my $x = doctx;
    is $got, ":ENTER:SCALAR:LEAVE:SCALAR",  "padblks in scalar ctx";

    $got = "";
    $x = doargs qw/ONE TWO/;
    is $got, ":ENTER:ONE:TWO:LEAVE:bar",    "\@_ in scalar ctx";

    $got = "";
    my @x = doctx;
    is $got, ":ENTER:LIST:LEAVE:LIST",      "padblks in list ctx";

    $got = "";
    @x = doargs qw/ONE TWO/;
    is $got, ":ENTER:ONE:TWO:LEAVE:foo:bar", "\@_ in list ctx";
}

$got = "";
eval {
    LEAVE { $got .= ":leave1" }
    die;
    LEAVE { $got .= ":leave2" }
};

is $got, ":leave2:leave1",
    "LEAVE called even on die";

$got = "";
eval {
    ENTER { die }
    LEAVE { $got .= ":leave1" }
    $got .= ":run1";
};

is $got, ":leave1",
    "LEAVE called even if ENTER dies";

$got = "";
eval {
    ENTER { $got .= ":enter1"; die }
    ENTER { $got .= ":enter2" }
};

is $got, ":enter1",
    "ENTER queue aborted on die";

$got = "";
eval {
    eval {
        LEAVE { $got .= ":leave1"; die }
    };
    $got .= ":eval1";
};

is $got, ":leave1:eval1",
    "die in LEAVE can be caught by eval";

$got = "";
eval {
    eval {
        LEAVE { $got .= ":leave1"; }
        LEAVE { $got .= ":leave2"; die }
    };
};

is $got, ":leave2:leave1",
    "LEAVE queue not aborted on die";

fresh_perl_is
    q{
        use feature "scopeblocks";
        ENTER { print ":enter1"; exit 0 }
        ENTER { print ":enter2" }
    },
    ":enter1",
    undef, "ENTER queue aborted on exit";

fresh_perl_is
    q{
        use feature "scopeblocks";
        ENTER { print ":enter1"; exit 0 }
        LEAVE { print ":leave1" }
        LEAVE { print ":leave2" }
    },
    ":enter1:leave2:leave1",
    undef, "LEAVE queue run on exit";

TODO: {
    local $::TODO = "I haven't worked out the JMPENV stuff yet";

    fresh_perl_is
        q{
            use feature "scopeblocks";
            LEAVE { print ":leave1" }
            LEAVE { print ":leave2"; exit 0 }
        },
        ":leave2:leave1",
        undef, "LEAVE queue not aborted on exit";
}

{
    my $x;

    @got = @want = ();

    for (1..2) {
        my $y;
        ENTER { push @got, "".\$y }
        push @want, "".\$y;
    }

    ok eq_array(\@got, \@want),         "ENTER captures lexicals";

    @got = @want = ();
    
    for (1..2) {
        my $y;
        LEAVE { push @got, "".\$y }
        push @want, "".\$y;
    }

    ok eq_array(\@got, \@want),         "LEAVE captures lexicals";

    $got = "";

    sub outer_lex {
        ENTER { $got = "".\$x }
    }
    outer_lex;

    is $got, "".\$x,                    "ENTER captures outer lexes";

    @got = @want = ();

    for (1..2) {
        my $y;
        sub { ENTER { push @got, "".\$x, "".\$y } }->();
        push @want, "".\$x, "".\$y;
    }

    ok eq_array(\@got, \@want),         "ENTER in closure";
}

{
    my $code = q{
        no warnings "prototype";
        BEGIN { *ENTER = sub (&) { print "sub" } }
        ENTER { print "padblk" }
    };

    fresh_perl_is $code, "sub", undef,  "no padblks without 'feature'";
    fresh_perl_is 'use feature "scopeblocks";' . $code, 
        "padblk", undef,                "padblks with 'feature'";
}

ok !@warns, "no warnings"
    or diag join "\n", @warns;
