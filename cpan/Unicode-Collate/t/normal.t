BEGIN {
    unless ("A" eq pack('U', 0x41)) {
	print "1..0 # Unicode::Collate " .
	    "cannot stringify a Unicode code point\n";
	exit 0;
    }
}

BEGIN {
    eval { require Unicode::Normalize; };
    if ($@) {
	print "1..0 # skipped: Unicode::Normalize needed for this test\n";
	print $@;
	exit;
    }
}
use Test;
BEGIN { plan tests => 100 };

use strict;
use warnings;
use Unicode::Collate;

our $Aring = pack('U', 0xC5);
our $aring = pack('U', 0xE5);

our $entry = <<'ENTRIES';
030A; [.0000.030A.0002] # COMBINING RING ABOVE
212B; [.002B.0020.0008] # ANGSTROM SIGN
0061; [.0A41.0020.0002] # LATIN SMALL LETTER A
0041; [.0A41.0020.0008] # LATIN CAPITAL LETTER A
007A; [.0A5A.0020.0002] # LATIN SMALL LETTER Z
005A; [.0A5A.0020.0008] # LATIN CAPITAL LETTER Z
FF41; [.0A87.0020.0002] # LATIN SMALL LETTER A
FF21; [.0A87.0020.0008] # LATIN CAPITAL LETTER A
00E5; [.0AC5.0020.0002] # LATIN SMALL LETTER A WITH RING ABOVE
00C5; [.0AC5.0020.0008] # LATIN CAPITAL LETTER A WITH RING ABOVE
ENTRIES

# Aong < A+ring < Z < fullA+ring < A-ring

#########################

our $noN = Unicode::Collate->new(
    level => 1,
    table => undef,
    normalization => undef,
    entry => $entry,
);

our $nfc = Unicode::Collate->new(
  level => 1,
  table => undef,
  normalization => 'NFC',
  entry => $entry,
);

our $nfd = Unicode::Collate->new(
  level => 1,
  table => undef,
  normalization => 'NFD',
  entry => $entry,
);

our $nfkc = Unicode::Collate->new(
  level => 1,
  table => undef,
  normalization => 'NFKC',
  entry => $entry,
);

our $nfkd = Unicode::Collate->new(
  level => 1,
  table => undef,
  normalization => 'NFKD',
  entry => $entry,
);

ok($noN->lt("\x{212B}", "A"));
ok($noN->lt("\x{212B}", $Aring));
ok($noN->lt("A\x{30A}", $Aring));
ok($noN->lt("A",       "\x{FF21}"));
ok($noN->lt("Z",       "\x{FF21}"));
ok($noN->lt("Z",        $Aring));
ok($noN->lt("\x{212B}", $aring));
ok($noN->lt("A\x{30A}", $aring));
ok($noN->lt("Z",        $aring));
ok($noN->lt("a\x{30A}", "Z"));

ok($nfd->eq("\x{212B}", "A"));
ok($nfd->eq("\x{212B}", $Aring));
ok($nfd->eq("A\x{30A}", $Aring));
ok($nfd->lt("A",       "\x{FF21}"));
ok($nfd->lt("Z",       "\x{FF21}"));
ok($nfd->gt("Z",        $Aring));
ok($nfd->eq("\x{212B}", $aring));
ok($nfd->eq("A\x{30A}", $aring));
ok($nfd->gt("Z",        $aring));
ok($nfd->lt("a\x{30A}", "Z"));

ok($nfc->gt("\x{212B}", "A"));
ok($nfc->eq("\x{212B}", $Aring));
ok($nfc->eq("A\x{30A}", $Aring));
ok($nfc->lt("A",       "\x{FF21}"));
ok($nfc->lt("Z",       "\x{FF21}"));
ok($nfc->lt("Z",        $Aring));
ok($nfc->eq("\x{212B}", $aring));
ok($nfc->eq("A\x{30A}", $aring));
ok($nfc->lt("Z",        $aring));
ok($nfc->gt("a\x{30A}", "Z"));

ok($nfkd->eq("\x{212B}", "A"));
ok($nfkd->eq("\x{212B}", $Aring));
ok($nfkd->eq("A\x{30A}", $Aring));
ok($nfkd->eq("A",       "\x{FF21}"));
ok($nfkd->gt("Z",       "\x{FF21}"));
ok($nfkd->gt("Z",        $Aring));
ok($nfkd->eq("\x{212B}", $aring));
ok($nfkd->eq("A\x{30A}", $aring));
ok($nfkd->gt("Z",        $aring));
ok($nfkd->lt("a\x{30A}", "Z"));

ok($nfkc->gt("\x{212B}", "A"));
ok($nfkc->eq("\x{212B}", $Aring));
ok($nfkc->eq("A\x{30A}", $Aring));
ok($nfkc->eq("A",       "\x{FF21}"));
ok($nfkc->gt("Z",       "\x{FF21}"));
ok($nfkc->lt("Z",        $Aring));
ok($nfkc->eq("\x{212B}", $aring));
ok($nfkc->eq("A\x{30A}", $aring));
ok($nfkc->lt("Z",        $aring));
ok($nfkc->gt("a\x{30A}", "Z"));

$nfd->change(normalization => undef);

ok($nfd->lt("\x{212B}", "A"));
ok($nfd->lt("\x{212B}", $Aring));
ok($nfd->lt("A\x{30A}", $Aring));
ok($nfd->lt("A",       "\x{FF21}"));
ok($nfd->lt("Z",       "\x{FF21}"));
ok($nfd->lt("Z",        $Aring));
ok($nfd->lt("\x{212B}", $aring));
ok($nfd->lt("A\x{30A}", $aring));
ok($nfd->lt("Z",        $aring));
ok($nfd->lt("a\x{30A}", "Z"));

$nfd->change(normalization => 'C');

ok($nfd->gt("\x{212B}", "A"));
ok($nfd->eq("\x{212B}", $Aring));
ok($nfd->eq("A\x{30A}", $Aring));
ok($nfd->lt("A",       "\x{FF21}"));
ok($nfd->lt("Z",       "\x{FF21}"));
ok($nfd->lt("Z",        $Aring));
ok($nfd->eq("\x{212B}", $aring));
ok($nfd->eq("A\x{30A}", $aring));
ok($nfd->lt("Z",        $aring));
ok($nfd->gt("a\x{30A}", "Z"));

$nfd->change(normalization => 'D');

ok($nfd->eq("\x{212B}", "A"));
ok($nfd->eq("\x{212B}", $Aring));
ok($nfd->eq("A\x{30A}", $Aring));
ok($nfd->lt("A",       "\x{FF21}"));
ok($nfd->lt("Z",       "\x{FF21}"));
ok($nfd->gt("Z",        $Aring));
ok($nfd->eq("\x{212B}", $aring));
ok($nfd->eq("A\x{30A}", $aring));
ok($nfd->gt("Z",        $aring));
ok($nfd->lt("a\x{30A}", "Z"));

$nfd->change(normalization => 'KD');

ok($nfd->eq("\x{212B}", "A"));
ok($nfd->eq("\x{212B}", $Aring));
ok($nfd->eq("A\x{30A}", $Aring));
ok($nfd->eq("A",       "\x{FF21}"));
ok($nfd->gt("Z",       "\x{FF21}"));
ok($nfd->gt("Z",        $Aring));
ok($nfd->eq("\x{212B}", $aring));
ok($nfd->eq("A\x{30A}", $aring));
ok($nfd->gt("Z",        $aring));
ok($nfd->lt("a\x{30A}", "Z"));

$nfd->change(normalization => 'KC');

ok($nfd->gt("\x{212B}", "A"));
ok($nfd->eq("\x{212B}", $Aring));
ok($nfd->eq("A\x{30A}", $Aring));
ok($nfd->eq("A",       "\x{FF21}"));
ok($nfd->gt("Z",       "\x{FF21}"));
ok($nfd->lt("Z",        $Aring));
ok($nfd->eq("\x{212B}", $aring));
ok($nfd->eq("A\x{30A}", $aring));
ok($nfd->lt("Z",        $aring));
ok($nfd->gt("a\x{30A}", "Z"));

