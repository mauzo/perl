#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Block::Util  PACKAGE = Block::Util

void
install_block(name, sub)
        SV  *name
        CV  *sub
    PPCODE:
        STRLEN len;
        const char *pv = SvPV(name, len);
        GV *gv;
       
        if (
            strnNE(pv, "ENTER", len) &&
            strnNE(pv, "LEAVE", len) &&
            strnNE(pv, "SCOPECHECK", len)
        )
            croak("Invalid special block name '%s'", pv);

        /* install block */

        XSRETURN_EMPTY;
