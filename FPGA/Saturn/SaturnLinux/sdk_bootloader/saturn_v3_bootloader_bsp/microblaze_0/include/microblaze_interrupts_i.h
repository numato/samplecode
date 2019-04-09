////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004 Xilinx, Inc.  All rights reserved. 
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
// $Id: microblaze_interrupts_i.h,v 1.1.2.1 2011/05/17 04:37:31 sadanan Exp $
////////////////////////////////////////////////////////////////////////////////

/*****************************************************************************/
/**
*
* @file microblaze_interrupts_i.h
*
* This header file contains identifiers and low-level driver functions (or
* macros) that can be used to access the device.  The user should refer to the
* hardware device specification for more details of the device operation.
* High-level driver functions are defined in xintc.h.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Date     Changes
* ----- -------- -----------------------------------------------
* 1.00b 10/03/03 First release
* </pre>
*
******************************************************************************/

#ifndef MICROBLAZE_INTERRUPTS_I_H /* prevent circular inclusions */
#define MICROBLAZE_INTERRUPTS_I_H /* by using protection macros */

/***************************** Include Files *********************************/

#include "xbasic_types.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
   XInterruptHandler Handler;
   void *CallBackRef;
} MB_InterruptVectorTableEntry;

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */
