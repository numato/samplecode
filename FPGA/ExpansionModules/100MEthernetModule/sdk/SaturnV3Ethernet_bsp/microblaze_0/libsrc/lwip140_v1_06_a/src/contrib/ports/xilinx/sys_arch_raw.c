/*
 * Copyright (c) 2007 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

#include "xlwipconfig.h"

#ifdef __MICROBLAZE__
#include "mb_interface.h"
#endif

#ifdef __PPC__
#include "xpseudo_asm_gcc.h"
#include "xexception_l.h"
#endif

#include "arch/cc.h"
#include "lwip/sys.h"

/*** IMPORTANT: Define PEEP in xemacpsif.h and sys_arch_raw.c
 *** to run it on a PEEP board
 ***/
/*
 * This optional function does a "fast" critical region protection and returns
 * the previous protection level. This function is only called during very short
 * critical regions. An embedded system which supports ISR-based drivers might
 * want to implement this function by disabling interrupts. Task-based systems
 * might want to implement this by using a mutex or disabling tasking. This
 * function should support recursive calls from the same task or interrupt. In
 * other words, sys_arch_protect() could be called while already protected. In
 * that case the return value indicates that it is already protected.
 * sys_arch_protect() is only required if your port is supporting an operating
 * system.
 */
sys_prot_t
sys_arch_protect()
{
	sys_prot_t cur;
#ifdef __MICROBLAZE__
	cur = mfmsr();
	mtmsr(cur & ~0x2);
#elif __PPC__
	cur = mfmsr();
	mtmsr(cur & ~XEXC_ALL);
#elif __arm__
#ifdef PEEP
	EmacDisableIntr();
#else
	cur = mfcpsr();
	mtcpsr(cur | 0xC0);
#endif
#endif
	return cur;
}

/*
 * This optional function does a "fast" set of critical region protection to the
 * value specified by pval. See the documentation for sys_arch_protect() for
 * more information. This function is only required if your port is supporting
 * an operating system.
 */
void
sys_arch_unprotect(sys_prot_t lev)
{
#ifdef __arm__
#ifdef PEEP
	EmacEnableIntr();
#else
	mtcpsr(lev);
#endif
#else
	mtmsr(lev);
#endif
}
