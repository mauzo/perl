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

        gv = gv_fetchpvn_flags(pv, len, GV_NOTQUAL|GV_ADDMULTI, SVt_PVCV);
        assert(gv);

        CvGV(sub) = gv;
        CvSPECIAL_on(sub);

        if (!PL_padblkav)
            PL_padblkav = newAV();
        av_push(PL_padblkav, SvREFCNT_inc(sub));

        XSRETURN_EMPTY;
