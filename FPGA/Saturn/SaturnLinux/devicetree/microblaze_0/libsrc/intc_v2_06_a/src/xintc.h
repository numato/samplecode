/******************************************************************************
*
* (c) Copyright 2002-2013 Xilinx, Inc. All rights reserved.
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
* @file xintc.h
*
* The Xilinx interrupt controller driver component. This component supports the
* Xilinx interrupt controller.
*
* The interrupt controller driver uses the idea of priority for the various
* handlers. Priority is an integer within the range of 0 and 31 inclusive with
* 0 being the highest priority interrupt source.
*
* The Xilinx interrupt controller supports the following features:
*
*   - specific individual interrupt enabling/disabling
*   - specific individual interrupt acknowledging
*   - attaching specific callback function to handle interrupt source
*   - master enable/disable
*   - single callback per interrupt or all pending interrupts handled for
*     each interrupt of the processor
*
* The acknowledgement of the interrupt within the interrupt controller is
* selectable, either prior to the device's handler being called or after
* the handler is called. This is necessary to support interrupt signal inputs
* which are either edge or level signals.  Edge driven interrupt signals
* require that the interrupt is acknowledged prior to the interrupt being
* serviced in order to prevent the loss of interrupts which are occurring
* extremely close together.  A level driven interrupt input signal requires
* the interrupt to acknowledged after servicing the interrupt to ensure that
* the interrupt only generates a single interrupt condition.
*
* Details about connecting the interrupt handler of the driver are contained
* in the source file specific to interrupt processing, xintc_intr.c.
*
* This driver is intended to be RTOS and processor independent.  It works with
* physical addresses only.  Any needs for dynamic memory management, threads
* or thread mutual exclusion, virtual memory, or cache control must be
* satisfied by the layer above this driver.
*
* <b>Interrupt Vector Tables</b>
*
* The interrupt vector table for each interrupt controller device is declared
* statically in xintc_g.c within the configuration data for each instance.
* The device ID of the interrupt controller device is used by the driver as a
* direct index into the configuration data table - to retrieve the vector table
* for an instance of the interrupt controller. The user should populate the
* vector table with handlers and callbacks at run-time using the XIntc_Connect()
* and XIntc_Disconnect() functions.
*
* Each vector table entry corresponds to a device that can generate an
* interrupt. Each entry contains an interrupt handler function and an argument
* to be passed to the handler when an interrupt occurs.  The tools default this
* argument to the base address of the interrupting device.  Note that the
* device driver interrupt handlers given in this file do not take a base
* address as an argument, but instead take a pointer to the driver instance.
* This means that although the table is created statically, the user must still
* use XIntc_Connect() when the interrupt handler takes an argument other than
* the base address. This is only to say that the existence of the static vector
* tables should not mislead the user into thinking they no longer need to
* register/connect interrupt handlers with this driver.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00a ecm  08/16/01 First release
* 1.00a rpm  01/09/02 Removed the AckLocation argument from XIntc_Connect().
*                     This information is now internal in xintc_g.c.
* 1.00b jhl  02/13/02 Repartitioned the driver for smaller files
* 1.00b jhl  04/24/02 Made LookupConfig function global and relocated config
*                     data type
* 1.00c rpm  10/17/03 New release. Support the static vector table created
*                     in the xintc_g.c configuration table. Moved vector
*                     table and options out of instance structure and into
*                     the configuration table.
* 1.10c mta  03/21/07 Updated to new coding style
* 1.11a sv   11/21/07 Updated driver to support access through a DCR bridge
* 2.00a ktn  10/20/09 Updated to use HAL Processor APIs and _m is removed from
*		      all the macro names/definitions.
* 2.01a sdm  04/27/10 Updated the tcl so that the defintions are generated in
*		      the xparameters.h to know whether the optional registers
*		      SIE, CIE and IVR are enabled in the HW - Refer CR 555392.
*		      This driver doesnot make use of these definitions and does
*		      not use the optional registers.
* 2.03a hvm  05/24/11 Updated the tcl to generate vector Ids for external
*		      interrupts. CR565336
* 2.04a bss  01/13/12 Added XIntc_ConnectFastHandler API for Fast Interrupt
*		      and XIntc_SetNormalIntrMode for setting to normal
*		      interrupt mode.
* 2.04a asa  03/19/12 Changed the XIntc_Config struct. The order of entries
*		      declared in the structure now matches with the
*		      XIntc_ConfigTable generated by the driver tcl.
* 2.05a bss  08/16/12 Updated to support relocatable vectors in Microblaze,
*		      added IntVectorAddr to XIntc_Config for this.
*		      Added XIntc_RegisterFastHandler API to register fast
*		      interrupt handlers using base address.
* 2.06a bss  01/28/13 To support Cascade mode:
* 		      Added XIN_INTC_NOCASCADE,XIN_INTC_PRIMARY,
*		      XIN_INTC_SECONDARY,XIN_INTC_LAST and
*		      XIN_CONTROLLER_MAX_INTRS  macros
*		      Added NumberofIntrs and IntcType fields in XIntc_Config
*		      structure.
*		      Modified XIntc_Initialize,XIntc_Start,XIntc_Connect
*		      XIntc_Disconnect,XIntc_Enable,XIntc_Disable,
*		      XIntc_Acknowledge,XIntc_ConnectFastHandler and
*		      XIntc_SetNormalIntrMode APIs.Added XIntc_InitializeSlaves
*		      API in xintc.c
*  		      Modified XIntc_DeviceInterruptHandler,
*  		      XIntc_SetIntrSvcOption,XIntc_RegisterHandler and
*		      XIntc_RegisterFastHandler APIs.Added XIntc_CascadeHandler
*		      API in xintc_l.c.
*		      Modified XIntc_SetOptions API in xintc_options.c.
*		      Modified XIntc_SimulateIntr API in xintc_selftest.c.
*		      Modified driver tcl:
*			to check for Cascade mode and generate XPAR_INTC_TYPE
*			for each controller.
*			Generate XPAR_INTC_MAX_NUM_INTR_INPUTS by adding all
*			interrupt sources of all Controllers in Cascade mode.
*
* @note
*		For Cascade mode, Interrupt IDs are generated in xparameters.h
*		as shown below:
*
*	    Master/Primary INTC
*		 ______
*		|      |-0      Secondary INTC
*		|      |-.         ______
*		|      |-.        |      |-32        Last INTC
*		|      |-.        |      |-.          ______
*		|______|<-31------|      |-.         |      |-64
*			          |      |-.         |      |-.
*			          |______|<-63-------|      |-.
*                                                    |      |-.
*                                                    |______|-95
*
*		All driver functions has to be called using DeviceId/
*		InstancePtr/BaseAddress of Primary/Master Controller and
*		Interrupts IDs generated in xparameters.h only.
*		Driver functions takes care of Slave Controllers based on
*		Interrupt ID passed. User must not use Interrupt source/ID
*		31 of Primary and Secondary controllers to call driver
*		functions.
* </pre>
*
******************************************************************************/

#ifndef XINTC_H			/* prevent circular inclusions */
#define XINTC_H			/* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif


/***************************** Include Files *********************************/

#include "xil_types.h"
#include "xil_assert.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xintc_l.h"

/************************** Constant Definitions *****************************/

/**
 * @name Configuration options
 * These options are used in XIntc_SetOptions() to configure the device.
 * @{
 */
/**
 * <pre>
 * XIN_SVC_SGL_ISR_OPTION	Service the highest priority pending interrupt
 *				and then return.
 * XIN_SVC_ALL_ISRS_OPTION	Service all of the pending interrupts and then
 *				return.
 * </pre>
 */
#define XIN_SVC_SGL_ISR_OPTION  1UL
#define XIN_SVC_ALL_ISRS_OPTION 2UL
/*@}*/

/**
 * @name Start modes
 * One of these values is passed to XIntc_Start() to start the device.
 * @{
 */
/** Simulation only mode, no hardware interrupts recognized */
#define XIN_SIMULATION_MODE     0
/** Real mode, no simulation allowed, hardware interrupts recognized */
#define XIN_REAL_MODE           1
/*@}*/

/**
 * @name Masks to specify Interrupt Controller Mode
 * @{
 */
#define XIN_INTC_NOCASCADE     	0	/* Normal - No Cascade Mode */
#define XIN_INTC_PRIMARY     	1	/* Master/Primary controller */
#define XIN_INTC_SECONDARY     	2	/* Secondary Slave Controllers */
#define XIN_INTC_LAST     	3	/* Last Slave Controller */

/*@}*/

/**
 * @name Mask to specify maximum number of interrupt sources per controller
 * @{
 */
#define XIN_CONTROLLER_MAX_INTRS	32  /* Each Controller has 32
					       interrupt pins */
/*@}*/

/**************************** Type Definitions *******************************/

/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/**< Unique ID  of device */
	u32 BaseAddress;	/**< Register base address */
	u32 AckBeforeService;	/**< Ack location per interrupt */
	int FastIntr;		/**< Fast Interrupt enabled */
	u32 IntVectorAddr;	/**< Interrupt Vector Address */
	int NumberofIntrs;      /**< Number of Interrupt sources */
	u32 Options;		/**< Device options */
	int IntcType;		/**< Intc type 0 - No Cascade Mode
				               1 - primary instance
				               2 - secondary instance
				               3 - last instance */

/** Static vector table of interrupt handlers */
#if XPAR_INTC_0_INTC_TYPE != XIN_INTC_NOCASCADE
	XIntc_VectorTableEntry HandlerTable[XIN_CONTROLLER_MAX_INTRS];
#else
	XIntc_VectorTableEntry HandlerTable[XPAR_INTC_MAX_NUM_INTR_INPUTS];
#endif

} XIntc_Config;

/**
 * The XIntc driver instance data. The user is required to allocate a
 * variable of this type for every intc device in the system. A pointer
 * to a variable of this type is then passed to the driver API functions.
 */
typedef struct {
	u32 BaseAddress;	 /**< Base address of registers */
	u32 IsReady;		 /**< Device is initialized and ready */
	u32 IsStarted;		 /**< Device has been started */
	u32 UnhandledInterrupts; /**< Intc Statistics */
	XIntc_Config *CfgPtr;	 /**< Pointer to instance config entry */

} XIntc;

/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

/*
 * Required functions in xintc.c
 */
int XIntc_Initialize(XIntc * InstancePtr, u16 DeviceId);

int XIntc_Start(XIntc * InstancePtr, u8 Mode);
void XIntc_Stop(XIntc * InstancePtr);

int XIntc_Connect(XIntc * InstancePtr, u8 Id,
		  XInterruptHandler Handler, void *CallBackRef);
void XIntc_Disconnect(XIntc * InstancePtr, u8 Id);

void XIntc_Enable(XIntc * InstancePtr, u8 Id);
void XIntc_Disable(XIntc * InstancePtr, u8 Id);

void XIntc_Acknowledge(XIntc * InstancePtr, u8 Id);

XIntc_Config *XIntc_LookupConfig(u16 DeviceId);

int XIntc_ConnectFastHandler(XIntc *InstancePtr, u8 Id,
				XFastInterruptHandler Handler);
void XIntc_SetNormalIntrMode(XIntc *InstancePtr, u8 Id);

/*
 * Interrupt functions in xintr_intr.c
 */
void XIntc_VoidInterruptHandler(void);
void XIntc_InterruptHandler(XIntc * InstancePtr);

/*
 * Options functions in xintc_options.c
 */
int XIntc_SetOptions(XIntc * InstancePtr, u32 Options);
u32 XIntc_GetOptions(XIntc * InstancePtr);

/*
 * Self-test functions in xintc_selftest.c
 */
int XIntc_SelfTest(XIntc * InstancePtr);
int XIntc_SimulateIntr(XIntc * InstancePtr, u8 Id);

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */
