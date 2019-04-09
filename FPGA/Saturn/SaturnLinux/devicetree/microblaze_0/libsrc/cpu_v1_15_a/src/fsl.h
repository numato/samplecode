/* $Id: fsl.h,v 1.1.2.2 2010/07/02 16:08:32 haibing Exp $ */
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
* @file fsl.h
*
* This file contains macros for interfacing to the Fast Simplex Link (FSL)
* interface..
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- ---------------------------------------------------
* 1.00a ecm  06/20/07 Initial version, moved over from bsp area
* 1.11c ecm  08/26/08 Fixed the missing 'FSL_DEFAULT' define that was causing
*					  assembly errors.
* </pre>
*
* @note
*
* None.
*
******************************************************************************/


#ifndef _FSL_H
#define _FSL_H

/***************************** Include Files *********************************/

#include "xbasic_types.h"

#ifdef __cplusplus
extern "C" {
#endif
/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/


/* if these have not been defined already, define here */
#ifndef stringify

/* necessary for pre-processor */
#define stringify(s)    tostring(s)
#define tostring(s)     #s

#endif /* stringify */

/* Extended FSL macros. These now replace all of the previous FSL macros */
#define FSL_DEFAULT
#define FSL_NONBLOCKING                          n
#define FSL_EXCEPTION                            e
#define FSL_CONTROL                              c
#define FSL_ATOMIC                               a

#define FSL_NONBLOCKING_EXCEPTION                ne
#define FSL_NONBLOCKING_CONTROL                  nc
#define FSL_NONBLOCKING_ATOMIC                   na
#define FSL_EXCEPTION_CONTROL                    ec
#define FSL_EXCEPTION_ATOMIC                     ea
#define FSL_CONTROL_ATOMIC                       ca

#define FSL_NONBLOCKING_EXCEPTION_CONTROL        nec
#define FSL_NONBLOCKING_EXCEPTION_ATOMIC         nea
#define FSL_NONBLOCKING_CONTROL_ATOMIC           nca
#define FSL_EXCEPTION_CONTROL_ATOMIC             eca

#define FSL_NONBLOCKING_EXCEPTION_CONTROL_ATOMIC neca

#define getfslx(val, id, flags)      asm volatile (stringify(flags) "get\t%0,rfsl" stringify(id) : "=d" (val))
#define putfslx(val, id, flags)      asm volatile (stringify(flags) "put\t%0,rfsl" stringify(id) :: "d" (val))

#define tgetfslx(val, id, flags)     asm volatile ("t" stringify(flags) "get\t%0,rfsl" stringify(id) : "=d" (val))
#define tputfslx(id, flags)          asm volatile ("t" stringify(flags) "put\trfsl" stringify(id))

#define getdfslx(val, var, flags)    asm volatile (stringify(flags) "getd\t%0,%1" : "=d" (val) : "d" (var))
#define putdfslx(val, var, flags)    asm volatile (stringify(flags) "putd\t%0,%1" :: "d" (val), "d" (var))

#define tgetdfslx(val, var, flags)   asm volatile ("t" stringify(flags) "getd\t%0,%1" : "=d" (val) : "d" (var))
#define tputdfslx(var, flags)        asm volatile ("t" stringify(flags) "putd\t%0" :: "d" (var))

/* if the mb_interface.h file has been included already, the following are not needed and will not be defined */

/* Legacy FSL Access Macros */

#ifndef getfsl

/* Blocking Data Read and Write to FSL no. id */
#define getfsl(val, id)         asm volatile ("get\t%0,rfsl" stringify(id) : "=d" (val))
#define putfsl(val, id)         asm volatile ("put\t%0,rfsl" stringify(id) :: "d" (val))

/* Non-blocking Data Read and Write to FSL no. id */
#define ngetfsl(val, id)        asm volatile ("nget\t%0,rfsl" stringify(id) : "=d" (val))
#define nputfsl(val, id)        asm volatile ("nput\t%0,rfsl" stringify(id) :: "d" (val))

/* Blocking Control Read and Write to FSL no. id */
#define cgetfsl(val, id)        asm volatile ("cget\t%0,rfsl" stringify(id) : "=d" (val))
#define cputfsl(val, id)        asm volatile ("cput\t%0,rfsl" stringify(id) :: "d" (val))

/* Non-blocking Control Read and Write to FSL no. id */
#define ncgetfsl(val, id)       asm volatile ("ncget\t%0,rfsl" stringify(id) : "=d" (val))
#define ncputfsl(val, id)       asm volatile ("ncput\t%0,rfsl" stringify(id) :: "d" (val))

/* Polling versions of FSL access macros. This makes the FSL access interruptible */
#define getfsl_interruptible(val, id)       asm volatile ("\n1:\n\tnget\t%0,rfsl" stringify(id) "\n\t"   \
                                                          "addic\tr18,r0,0\n\t"                \
                                                          "bnei\tr18,1b\n"                     \
                                                           : "=d" (val) :: "r18")

#define putfsl_interruptible(val, id)       asm volatile ("\n1:\n\tnput\t%0,rfsl" stringify(id) "\n\t"   \
                                                          "addic\tr18,r0,0\n\t"                \
                                                          "bnei\tr18,1b\n"                     \
                                                          :: "d" (val) : "r18")

#define cgetfsl_interruptible(val, id)      asm volatile ("\n1:\n\tncget\t%0,rfsl" stringify(id) "\n\t"  \
                                                          "addic\tr18,r0,0\n\t"                \
                                                          "bnei\tr18,1b\n"                     \
                                                          : "=d" (val) :: "r18")

#define cputfsl_interruptible(val, id)      asm volatile ("\n1:\n\tncput\t%0,rfsl" stringify(id) "\n\t"  \
                                                          "addic\tr18,r0,0\n\t"                \
                                                          "bnei\tr18,1b\n"                     \
                                                          :: "d" (val) : "r18")
/* FSL valid and error check macros. */
#define fsl_isinvalid(result)               asm volatile ("addic\t%0,r0,0"  : "=d" (result))
#define fsl_iserror(error)                  asm volatile ("mfs\t%0,rmsr\n\t"  \
                                                              "andi\t%0,%0,0x10" : "=d" (error))

#endif /* legacy FSL defines */
/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/

#ifdef __cplusplus
}
#endif
#endif /* _FSL_H */

