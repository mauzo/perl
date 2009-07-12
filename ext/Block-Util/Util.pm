package Block::Util;

use strict;
use warnings;

use version; our $VERSION = "0.01";

use XSLoader;
XSLoader::load __PACKAGE__, $VERSION;

use Exporter "import";
our @EXPORT_OK = qw/install_block/;

1;
