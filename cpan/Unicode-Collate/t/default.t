
BEGIN {
    unless ("A" eq pack('U', 0x41)) {
	print "1..0 # Unicode::Collate " .
	    "cannot stringify a Unicode code point\n";
	exit 0;
    }
}

use Test;
BEGIN { plan tests => 52 };

use strict;
use warnings;
use Unicode::Collate;

ok(1);

sub _pack_U   { Unicode::Collate::pack_U(@_) }
sub _unpack_U { Unicode::Collate::unpack_U(@_) }

my $A_acute = _pack_U(0xC1);
my $a_acute = _pack_U(0xE1);
my $acute   = _pack_U(0x0301);

my $hiragana = "\x{3042}\x{3044}";
my $katakana = "\x{30A2}\x{30A4}";

##### 2..7

my $Collator = Unicode::Collate->new(
  normalization => undef,
);

ok(ref $Collator, "Unicode::Collate");

ok($Collator->cmp("", ""), 0);
ok($Collator->eq("", ""));
ok($Collator->cmp("", "perl"), -1);

ok(
  join(':', $Collator->sort( qw/ acha aca ada acia acka / ) ),
  join(':',                  qw/ aca acha acia acka ada / ),
);

ok(
  join(':', $Collator->sort( qw/ ACHA ACA ADA ACIA ACKA / ) ),
  join(':',                  qw/ ACA ACHA ACIA ACKA ADA / ),
);

##### 8..18

ok($Collator->cmp("A$acute", $A_acute), 0); # @version 3.1.1 (prev: -1)
ok($Collator->cmp($a_acute, $A_acute), -1);
ok($Collator->eq("A\cA$acute", $A_acute)); # UCA v9. \cA is invariant.

my %old_level = $Collator->change(level => 1);
ok($Collator->eq("A$acute", $A_acute));
ok($Collator->eq("A", $A_acute));

ok($Collator->change(level => 2)->eq($a_acute, $A_acute));
ok($Collator->lt("A", $A_acute));

ok($Collator->change(%old_level)->lt("A", $A_acute));
ok($Collator->lt("A", $A_acute));
ok($Collator->lt("A", $a_acute));
ok($Collator->lt($a_acute, $A_acute));

##### 19..25

$Collator->change(level => 2);

ok($Collator->{level}, 2);

ok( $Collator->cmp("ABC","abc"), 0);
ok( $Collator->eq("ABC","abc") );
ok( $Collator->le("ABC","abc") );
ok( $Collator->cmp($hiragana, $katakana), 0);
ok( $Collator->eq($hiragana, $katakana) );
ok( $Collator->ge($hiragana, $katakana) );

##### 26..31

# hangul
ok( $Collator->eq("a\x{AC00}b", "a\x{1100}\x{1161}b") );
ok( $Collator->eq("a\x{AE00}b", "a\x{1100}\x{1173}\x{11AF}b") );
ok( $Collator->gt("a\x{AE00}b", "a\x{1100}\x{1173}b\x{11AF}") );
ok( $Collator->lt("a\x{AC00}b", "a\x{AE00}b") );
ok( $Collator->gt("a\x{D7A3}b", "a\x{C544}b") );
ok( $Collator->lt("a\x{C544}b", "a\x{30A2}b") ); # hangul < hiragana

##### 32..40

$Collator->change(%old_level, katakana_before_hiragana => 1);

ok($Collator->{level}, 4);

ok( $Collator->cmp("abc", "ABC"), -1);
ok( $Collator->ne("abc", "ABC") );
ok( $Collator->lt("abc", "ABC") );
ok( $Collator->le("abc", "ABC") );
ok( $Collator->cmp($hiragana, $katakana), 1);
ok( $Collator->ne($hiragana, $katakana) );
ok( $Collator->gt($hiragana, $katakana) );
ok( $Collator->ge($hiragana, $katakana) );

##### 41..46

$Collator->change(upper_before_lower => 1);

ok( $Collator->cmp("abc", "ABC"), 1);
ok( $Collator->ge("abc", "ABC"), 1);
ok( $Collator->gt("abc", "ABC"), 1);
ok( $Collator->cmp($hiragana, $katakana), 1);
ok( $Collator->ge($hiragana, $katakana), 1);
ok( $Collator->gt($hiragana, $katakana), 1);

##### 47..48

$Collator->change(katakana_before_hiragana => 0);

ok( $Collator->cmp("abc", "ABC"), 1);
ok( $Collator->cmp($hiragana, $katakana), -1);

##### 49..52

$Collator->change(upper_before_lower => 0);

ok( $Collator->cmp("abc", "ABC"), -1);
ok( $Collator->le("abc", "ABC") );
ok( $Collator->cmp($hiragana, $katakana), -1);
ok( $Collator->lt($hiragana, $katakana) );
