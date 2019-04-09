////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004-2010 Xilinx, Inc.  All rights reserved.
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
// $Id: microblaze_interrupt_handler.c,v 1.1.2.1 2011/05/17 04:37:30 sadanan Exp $
////////////////////////////////////////////////////////////////////////////////

/*****************************************************************************/
/**
*
* @file microblaze_interrupt_handler.c
*
* This file contains the standard interrupt handler for the MicroBlaze processor.
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


/***************************** Include Files *********************************/

#include "microblaze_interrupts_i.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

void __interrupt_handler (void) __attribute__ ((interrupt_handler));

/************************** Variable Definitions *****************************/

extern MB_InterruptVectorTableEntry MB_InterruptVectorTable;
/*****************************************************************************/
/**
*
* This function is the standard interrupt handler used by the MicroBlaze processor.
* It saves all volatile registers, calls the users top level interrupt handler.
* When this returns, it restores all registers, and returns using a rtid instruction.
*
* @param
*
* None
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void __interrupt_handler(void)
{
	/* The compiler saves all volatiles and the MSR */
	MB_InterruptVectorTable.Handler(MB_InterruptVectorTable.CallBackRef);
	/* The compiler restores all volatiles and MSR, and returns from interrupt */
}

/****************************************************************************/
/*****************************************************************************/
/**
*
* Registers a top-level interrupt handler for the MicroBlaze. The
* argument provided in this call as the DataPtr is used as the argument
* for the handler when it is called.
*
* @param    Top level handler.
* @param    DataPtr is a reference to data that will be passed to the handler
*           when it gets called.

* @return   None.
*
* @note
*
* None.
*
****************************************************************************/
void microblaze_register_handler(XInterruptHandler Handler, void *DataPtr)
{
   MB_InterruptVectorTable.Handler = Handler;
   MB_InterruptVectorTable.CallBackRef = DataPtr;
}

