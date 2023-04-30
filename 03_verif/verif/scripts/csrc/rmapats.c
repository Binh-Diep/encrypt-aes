// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1211, EBLK  * I1205, U  I670);
void  hsG_0__0 (struct dummyq_struct * I1211, EBLK  * I1205, U  I670)
{
    U  I1462;
    U  I1463;
    U  I1464;
    struct futq * I1465;
    struct dummyq_struct * pQ = I1211;
    I1462 = ((U )vcs_clocks) + I670;
    I1464 = I1462 & ((1 << fHashTableSize) - 1);
    I1205->I722 = (EBLK  *)(-1);
    I1205->I726 = I1462;
    if (I1462 < (U )vcs_clocks) {
        I1463 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1205, I1463 + 1, I1462);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I670 == 1)) {
        I1205->I728 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I722 = I1205;
        peblkFutQ1Tail = I1205;
    }
    else if ((I1465 = pQ->I1115[I1464].I740)) {
        I1205->I728 = (struct eblk *)I1465->I739;
        I1465->I739->I722 = (RP )I1205;
        I1465->I739 = (RmaEblk  *)I1205;
    }
    else {
        sched_hsopt(pQ, I1205, I1462);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
