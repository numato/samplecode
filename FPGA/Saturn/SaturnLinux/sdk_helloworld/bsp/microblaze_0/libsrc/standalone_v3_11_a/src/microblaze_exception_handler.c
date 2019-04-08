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
// $Id: microblaze_exception_handler.c,v 1.1.2.1 2011/05/17 04:37:28 sadanan Exp $
////////////////////////////////////////////////////////////////////////////////

/*****************************************************************************/
/**
*
* @file microblaze_exception_handler.c
*
* This file contains exception handler registration routines for
* the MicroBlaze processor.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Date     Changes
* ----- -------- -----------------------------------------------
* 1.00b 06/24/04 First release
* </pre>
*
******************************************************************************/


/***************************** Include Files *********************************/
#include "microblaze_exceptions_i.h"
#include "microblaze_exceptions_g.h"

#ifdef MICROBLAZE_EXCEPTIONS_ENABLED                    /* If exceptions are enabled in the processor */
/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/
extern MB_ExceptionVectorTableEntry MB_ExceptionVectorTable[];
/****************************************************************************/

/*****************************************************************************/
/**
*
* Registers an exception handler for the MicroBlaze. The
* argument provided in this call as the DataPtr is used as the argument
* for the handler when it is called.
*
* @param    ExceptionId is the id of the exception to register this handler 
*           for.
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
void microblaze_register_exception_handler(Xuint8 ExceptionId, XExceptionHandler Handler, void *DataPtr)
{
   MB_ExceptionVectorTable[ExceptionId].Handler = Handler;
   MB_ExceptionVectorTable[ExceptionId].CallBackRef = DataPtr;
}

#endif  /* MICROBLAZE_EXCEPTIONS_ENABLED */
