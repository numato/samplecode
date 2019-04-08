////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004-2011 Xilinx, Inc.  All rights reserved. 
// 
// Xilinx, Inc. 
// XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A 
// COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS 
// ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR 
// STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION 
// IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE 
// FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION. 
// XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO 
// THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO 
// ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE 
// FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY 
// AND FITNESS FOR A PARTICULAR PURPOSE.
//
// $Id: microblaze_exceptions_i.h,v 1.1.2.1 2011/05/17 04:37:29 sadanan Exp $
////////////////////////////////////////////////////////////////////////////////

/*****************************************************************************/
/**
*
* @file microblaze_exceptions_i.h
*
* This header file contains defines for structures used by the microblaze 
* hardware exception handler.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Date     Changes
* ----- -------- -----------------------------------------------
* 1.00a 06/24/04 First release
* </pre>
*
******************************************************************************/

#ifndef MICROBLAZE_EXCEPTIONS_I_H /* prevent circular inclusions */
#define MICROBLAZE_EXCEPTIONS_I_H /* by using protection macros */

/***************************** Include Files *********************************/

#include "xbasic_types.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
   XExceptionHandler Handler;
   void *CallBackRef;
} MB_ExceptionVectorTableEntry;

/* Exception IDs */
#define XEXC_ID_FSL                     0
#define XEXC_ID_UNALIGNED_ACCESS        1
#define XEXC_ID_ILLEGAL_OPCODE          2
#define XEXC_ID_M_AXI_I_EXCEPTION       3
#define XEXC_ID_IPLB_EXCEPTION          3
#define XEXC_ID_M_AXI_D_EXCEPTION       4
#define XEXC_ID_DPLB_EXCEPTION          4
#define XEXC_ID_DIV_BY_ZERO             5
#define XEXC_ID_FPU                     6
#define XEXC_ID_STACK_VIOLATION         7
#define XEXC_ID_MMU                     7

void microblaze_register_exception_handler(Xuint8 ExceptionId, XExceptionHandler Handler, void *DataPtr);

#ifdef __cplusplus
}
#endif
#endif /* end of protection macro */
