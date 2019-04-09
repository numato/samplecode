/******************************************************************************
* Copyright (c) 2008-2013 Xilinx, Inc.  All rights reserved. 
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
* microblaze_invalidate_cache_ext()
*
*Invalidate the entire L2 Cache 
*
*
*******************************************************************************/

#include "xparameters.h"

#define XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN	16

	.text
	.globl	microblaze_invalidate_cache_ext
	.ent	microblaze_invalidate_cache_ext
	.align	2

microblaze_invalidate_cache_ext:

#if ((XPAR_MICROBLAZE_INTERCONNECT==3) && (XPAR_MICROBLAZE_USE_DCACHE==1))
	addik	r5, r0, XPAR_MICROBLAZE_DCACHE_BASEADDR & (-(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN))
	
	addik	r6, r0, XPAR_MICROBLAZE_DCACHE_BYTE_SIZE-(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN)
 	andi	r6, r6, -(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN)

Loop_start:
	wdc.ext.clear	r5, r6
	bgtid	r6,Loop_start
	addik	r6, r6,-(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN)
#endif	
	rtsd	r15, 8
	nop

	.end	microblaze_invalidate_cache_ext

	
  
