/* $Id: xio.h,v 1.1.2.2 2010/06/16 11:15:32 sadanan Exp $ */
/******************************************************************************
*
* (c) Copyright 2007-2009 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xio.h
*
* This file contains the interface for the XIo component, which encapsulates
* the Input/Output functions for processors that do not require any special
* I/O handling.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00a rpm  11/07/03 Added InSwap/OutSwap routines for endian conversion
* 1.00a xd   11/04/04 Improved support for doxygen
* 1.01a ecm  02/24/06 CR225908 corrected the extra curly braces in macros
*                     and bumped version to 1.01.a.
* 1.11a mta  03/21/07 Updated to new coding style.
* 1.11b va   04/17/08 Updated Tcl for better CORE_CLOCK_FREQ_HZ definition
* 1.11a sdm  03/12/09 Updated Tcl to define correct value for CORE_CLOCK_FREQ_HZ
*                     (CR  #502010)
* 1.13a sdm  03/12/09 Updated the Tcl to pull appropriate libraries for Little
*                     Endian Microblaze
*
* </pre>
*
* @note
*
* This file may contain architecture-dependent items (memory-mapped or
* non-memory-mapped I/O).
*
******************************************************************************/

#ifndef XIO_H			/* prevent circular inclusions */
#define XIO_H			/* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/

#include "xbasic_types.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/

/**
 * Typedef for an I/O address.  Typically correlates to the width of the
 * address bus.
 */
typedef u32 XIo_Address;

/***************** Macros (Inline Functions) Definitions *********************/

/*
 * The following macros allow optimized I/O operations for memory mapped I/O.
 * It should be noted that macros cannot be used if synchronization of the I/O
 * operation is needed as it will likely break some code.
 */

/*****************************************************************************/
/**
*
* Performs an input operation for an 8-bit memory location by reading from the
* specified address and returning the value read from that address.
*
* @param	InputPtr contains the address to perform the input operation at.
*
* @return	The value read from the specified input address.
*
* @note		None.
*
******************************************************************************/
#define XIo_In8(InputPtr)  (*(volatile u8  *)(InputPtr))

/*****************************************************************************/
/**
*
* Performs an input operation for a 16-bit memory location by reading from the
* specified address and returning the value read from that address.
*
* @param	InputPtr contains the address to perform the input operation at.
*
* @return	The value read from the specified input address.
*
* @note		None.
*
******************************************************************************/
#define XIo_In16(InputPtr) (*(volatile u16 *)(InputPtr))

/*****************************************************************************/
/**
*
* Performs an input operation for a 32-bit memory location by reading from the
* specified address and returning the value read from that address.
*
* @param	InputPtr contains the address to perform the input operation at.
*
* @return	The value read from the specified input address.
*
* @note		None.
*
******************************************************************************/
#define XIo_In32(InputPtr)  (*(volatile u32 *)(InputPtr))


/*****************************************************************************/
/**
*
* Performs an output operation for an 8-bit memory location by writing the
* specified value to the the specified address.
*
* @param	OutputPtr contains the address to perform the output operation
*		at.
* @param	Value contains the value to be output at the specified address.
*
* @return	None
*
* @note		None.
*
******************************************************************************/
#define XIo_Out8(OutputPtr, Value)  \
	(*(volatile u8  *)((OutputPtr)) = (Value))

/*****************************************************************************/
/**
*
* Performs an output operation for a 16-bit memory location by writing the
* specified value to the the specified address.
*
* @param	OutputPtr contains the address to perform the output operation
*		at.
* @param	Value contains the value to be output at the specified address.
*
* @return	None
*
* @note		None.
*
******************************************************************************/
#define XIo_Out16(OutputPtr, Value) \
	(*(volatile u16 *)((OutputPtr)) = (Value))

/*****************************************************************************/
/**
*
* Performs an output operation for a 32-bit memory location by writing the
* specified value to the the specified address.
*
* @param	OutputPtr contains the address to perform the output operation
*		at.
* @param	Value contains the value to be output at the specified address.
*
* @return	None
*
* @note		None.
*
******************************************************************************/
#define XIo_Out32(OutputPtr, Value) \
	(*(volatile u32 *)((OutputPtr)) = (Value))


/* The following macros allow the software to be transportable across
 * processors which use big or little endian memory models.
 *
 * Defined first is a no-op endian conversion macro. This macro is not to
 * be used directly by software. Instead, the XIo_To/FromLittleEndianXX and
 * XIo_To/FromBigEndianXX macros below are to be used to allow the endian
 * conversion to only be performed when necessary
 */
#define XIo_EndianNoop(Source, DestPtr)		(*DestPtr = Source)

#ifdef XLITTLE_ENDIAN

#define XIo_ToLittleEndian16			XIo_EndianNoop
#define XIo_ToLittleEndian32			XIo_EndianNoop
#define XIo_FromLittleEndian16			XIo_EndianNoop
#define XIo_FromLittleEndian32			XIo_EndianNoop

#define XIo_ToBigEndian16(Source, DestPtr) XIo_EndianSwap16(Source, DestPtr)
#define XIo_ToBigEndian32(Source, DestPtr) XIo_EndianSwap32(Source, DestPtr)
#define XIo_FromBigEndian16			XIo_ToBigEndian16
#define XIo_FromBigEndian32			XIo_ToBigEndian32

#else

#define XIo_ToLittleEndian16(Source, DestPtr) XIo_EndianSwap16(Source, DestPtr)
#define XIo_ToLittleEndian32(Source, DestPtr) XIo_EndianSwap32(Source, DestPtr)
#define XIo_FromLittleEndian16			XIo_ToLittleEndian16
#define XIo_FromLittleEndian32			XIo_ToLittleEndian32

#define XIo_ToBigEndian16			XIo_EndianNoop
#define XIo_ToBigEndian32			XIo_EndianNoop
#define XIo_FromBigEndian16			XIo_EndianNoop
#define XIo_FromBigEndian32			XIo_EndianNoop

#endif

/************************** Function Prototypes ******************************/

/* The following functions allow the software to be transportable across
 * processors which use big or little endian memory models. These functions
 * should not be directly called, but the macros XIo_To/FromLittleEndianXX and
 * XIo_To/FromBigEndianXX should be used to allow the endian conversion to only
 * be performed when necessary.
 */
void XIo_EndianSwap16(u16 Source, u16 *DestPtr);
void XIo_EndianSwap32(u32 Source, u32 *DestPtr);

/* The following functions handle IO addresses where data must be swapped
 * They cannot be implemented as macros
 */
u16 XIo_InSwap16(XIo_Address InAddress);
u32 XIo_InSwap32(XIo_Address InAddress);
void XIo_OutSwap16(XIo_Address OutAddress, u16 Value);
void XIo_OutSwap32(XIo_Address OutAddress, u32 Value);

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */
