/*********************************************************************************
* Copyright (c) 2006 Xilinx, Inc.  All rights reserved. 
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
* File   : microblaze_update_dcache.s
* Date   : 2003, September 24
* Company: Xilinx
* Group  : Emerging Software Technologies
*
* Summary:
* Update dcache on the microblaze.
* Takes in three parameters
*	r5 : Cache Tag Line
*	r6 : Cache Data
*	r7 : Lock/Valid information
*		Bit 30 is Lock  [ 1 indicates locked ]
*		Bit 31 is Valid [ 1 indicates valid ]
*
*	--------------------------------------------------------------
*	|  Lock	 |     Valid  | Effect
*	--------------------------------------------------------------
*	|   0    |      0     | Invalidate Cache
*       |   0    |      1     | Valid, but unlocked cacheline
*       |   1    |      0     | Invalidate Cache, No effect of lock
*       |   1    |      1     | Valid cache. Locked to a 
*       |        |            | particular addrees
*	--------------------------------------------------------------
*
* $Id: microblaze_update_dcache.S,v 1.1.2.1 2011/05/17 04:37:32 sadanan Exp $
*
**********************************************************************************/
#include "xparameters.h"
    
#ifndef XPAR_MICROBLAZE_DCACHE_LINE_LEN
#define XPAR_MICROBLAZE_DCACHE_LINE_LEN   1
#endif

	.text
	.globl	microblaze_update_dcache
	.ent	microblaze_update_dcache
	.align	2
microblaze_update_dcache:

#if XPAR_MICROBLAZE_DCACHE_LINE_LEN == 1

/* Read the MSR register into a temp register */
	mfs	r18, rmsr

/* Clear the dcache enable bit to disable the cache
   Register r10,r18 are  volatile registers and hence do not need to be saved before use */
	andi	r10, r18, ~128
	mts	rmsr, r10

/* Update the lock and valid info */
	andi	r5, r5, 0xfffffffc
	or	r5, r5, r7

/* Update dcache */
	wdc	r5, r6

/* Return */
	rtsd	r15, 8
	mts	rmsr, r18

#else

        /* The only valid usage of this routine for larger cache line lengths is to invalidate a data cache line
           So call microblaze_init_dcache_range appropriately to do the job   */

        brid    microblaze_init_dcache_range
        addik   r6, r0, (XPAR_MICROBLAZE_DCACHE_LINE_LEN * 4)

        /* We don't have a return instruction here. This is tail call optimization :) */
    
#endif /* XPAR_MICROBLAZE_DCACHE_LINE_LEN == 1 */

	.end	microblaze_update_dcache
