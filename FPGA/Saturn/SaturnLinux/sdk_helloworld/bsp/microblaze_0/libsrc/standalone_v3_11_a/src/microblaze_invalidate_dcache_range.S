/******************************************************************************
* Copyright (c) 2008 Xilinx, Inc.  All rights reserved. 
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
* microblaze_invalidate_dcache_range (unsigned int cacheaddr, unsigned int len)
*    
*    Invalidate a Dcache range
*    
*    Parameters:  
*       'cacheaddr' - address in the Dcache where invalidation begins
*	'len    '   - length (in bytes) worth of Dcache to be invalidated
*
* $Id: microblaze_invalidate_dcache_range.S,v 1.1.2.1 2011/05/17 04:37:31 sadanan Exp $
*
*******************************************************************************/

#include "xparameters.h"

#define MICROBLAZE_MSR_DCACHE_ENABLE        0x00000080
#define MICROBLAZE_MSR_INTR_ENABLE          0x00000002
    
#ifndef XPAR_MICROBLAZE_DCACHE_LINE_LEN
#define XPAR_MICROBLAZE_DCACHE_LINE_LEN     1
#endif

#ifndef XPAR_MICROBLAZE_DCACHE_USE_WRITEBACK
#define MB_VERSION_LT_v720
#define MB_HAS_WRITEBACK_SET 0
#else
#define MB_HAS_WRITEBACK_SET XPAR_MICROBLAZE_DCACHE_USE_WRITEBACK
#endif
   
	.text
	.globl	microblaze_invalidate_dcache_range
	.ent	microblaze_invalidate_dcache_range
	.align	2

microblaze_invalidate_dcache_range:

        
#ifdef MB_VERSION_LT_v720                                       /* Disable Dcache and interrupts before invalidating */    
	mfs	r9, rmsr                    
	andi	r10, r9, ~(MICROBLAZE_MSR_DCACHE_ENABLE | MICROBLAZE_MSR_INTR_ENABLE)
	mts	rmsr, r10
#endif

        beqi    r6, L_done                                      /* Skip loop if size is zero */
    
        add	r6, r5, r6                                      /* Compute end address */
        addik   r6, r6, -1
    
        andi    r6, r6, -(4 * XPAR_MICROBLAZE_DCACHE_LINE_LEN)  /* Align end down to cache line */   
        andi    r5, r5, -(4 * XPAR_MICROBLAZE_DCACHE_LINE_LEN)  /* Align start down to cache line */
    
#if MB_HAS_WRITEBACK_SET == 0                                   /* Use a different scheme for MB version < v7.20 or when caches are write-through */
    
L_start:
    	cmpu	r18, r5, r6                                     /* Are we at the end? */
	blti	r18, L_done                                     
    
	wdc     r5, r0                                        
    
     	brid	L_start                                         /* Branch to the beginning of the loop */
	addik	r5, r5, (XPAR_MICROBLAZE_DCACHE_LINE_LEN * 4)   /* Increment the addrees by 4 (delay slot) */
#else

        rsubk   r6, r5, r6                                      
                                                                /* r6 will now contain (count of bytes - (4 * XPAR_MICROBLAZE_DCACHE_LINE_LEN)) */
L_start:
        wdc.clear r5, r6                                        /* Invalidate the cache line only if the address matches */
        bneid   r6, L_start
        addik   r6, r6, -(XPAR_MICROBLAZE_DCACHE_LINE_LEN * 4)

#endif
    
L_done:	
	rtsd	r15, 8                                          
#ifdef MB_VERSION_LT_v720                                       /* restore MSR only for MB version < v7.20 */
	mts	rmsr, r9
#else
        nop
#endif
	.end	microblaze_invalidate_dcache_range

	
  
