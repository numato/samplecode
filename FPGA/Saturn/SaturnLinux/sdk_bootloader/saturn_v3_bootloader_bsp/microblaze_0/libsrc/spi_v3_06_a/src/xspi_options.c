/* $Id: xspi_options.c,v 1.1.2.1 2011/08/09 06:59:27 svemula Exp $ */
/******************************************************************************
*
* (c) Copyright 2001-2013 Xilinx, Inc. All rights reserved.
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
* @file xspi_options.c
*
* Contains functions for the configuration of the XSpi driver component.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00b jhl  2/27/02  First release
* 1.00b rpm  04/25/02 Collapsed IPIF and reg base addresses into one
* 1.11a wgr  03/22/07 Converted to new coding style.
* 3.00a ktn  10/28/09 Updated all the register accesses as 32 bit access.
*		      Updated driver to use the HAL APIs/macros.
*
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xspi.h"
#include "xspi_i.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


/************************** Variable Definitions *****************************/

/*
 * Create the table of options which are processed to get/set the device
 * options. These options are table driven to allow easy maintenance and
 * expansion of the options.
 */
typedef struct {
	u32 Option;
	u32 Mask;
} OptionsMap;

static OptionsMap OptionsTable[] = {
	{XSP_LOOPBACK_OPTION, XSP_CR_LOOPBACK_MASK},
	{XSP_CLK_ACTIVE_LOW_OPTION, XSP_CR_CLK_POLARITY_MASK},
	{XSP_CLK_PHASE_1_OPTION, XSP_CR_CLK_PHASE_MASK},
	{XSP_MASTER_OPTION, XSP_CR_MASTER_MODE_MASK},
	{XSP_MANUAL_SSELECT_OPTION, XSP_CR_MANUAL_SS_MASK}
};

#define XSP_NUM_OPTIONS		(sizeof(OptionsTable) / sizeof(OptionsMap))

/*****************************************************************************/
/**
*
* This function sets the options for the SPI device driver. The options control
* how the device behaves relative to the SPI bus. The device must be idle
* rather than busy transferring data before setting these device options.
*
* @param	InstancePtr is a pointer to the XSpi instance to be worked on.
* @param	Options contains the specified options to be set. This is a bit
*		mask where a 1 means to turn the option on, and a 0 means to
*		turn the option off. One or more bit values may be contained in
*		the mask.
*		See the bit definitions named XSP_*_OPTIONS in the file xspi.h.
*
* @return
*		-XST_SUCCESS if options are successfully set.
*		- XST_DEVICE_BUSY if the device is currently transferring data.
*		The transfer must complete or be aborted before setting options.
*		- XST_SPI_SLAVE_ONLY if the caller attempted to configure a
*		slave-only device as a master.
*
* @note
*
* This function makes use of internal resources that are shared between the
* XSpi_Stop() and XSpi_SetOptions() functions. So if one task might be setting
* device options while another is trying to stop the device, the user is
* required to provide protection of this shared data (typically using a
* semaphore).
*
******************************************************************************/
int XSpi_SetOptions(XSpi *InstancePtr, u32 Options)
{
	u32 ControlReg;
	u32 Index;

	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

	/*
	 * Do not allow the slave select to change while a transfer is in
	 * progress.
	 * No need to worry about a critical section here since even if the Isr
	 * changes the busy flag just after we read it, the function will return
	 * busy and the caller can retry when notified that their current
	 * transfer is done.
	 */
	if (InstancePtr->IsBusy) {
		return XST_DEVICE_BUSY;
	}
	/*
	 * Do not allow master option to be set if the device is slave only.
	 */
	if ((Options & XSP_MASTER_OPTION) && (InstancePtr->SlaveOnly)) {
		return XST_SPI_SLAVE_ONLY;
	}

	ControlReg = XSpi_GetControlReg(InstancePtr);

	/*
	 * Loop through the options table, turning the option on or off
	 * depending on whether the bit is set in the incoming options flag.
	 */
	for (Index = 0; Index < XSP_NUM_OPTIONS; Index++) {
		if (Options & OptionsTable[Index].Option) {
			/*
			 *Turn it ON.
			 */
			ControlReg |= OptionsTable[Index].Mask;
		}
		else {
			/*
			 *Turn it OFF.
			 */
			ControlReg &= ~OptionsTable[Index].Mask;
		}
	}

	/*
	 * Now write the control register. Leave it to the upper layers
	 * to restart the device.
	 */
	XSpi_SetControlReg(InstancePtr, ControlReg);

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function gets the options for the SPI device. The options control how
* the device behaves relative to the SPI bus.
*
* @param	InstancePtr is a pointer to the XSpi instance to be worked on.
*
* @return
*
* Options contains the specified options to be set. This is a bit mask where a
* 1 means to turn the option on, and a 0 means to turn the option off. One or
* more bit values may be contained in the mask. See the bit definitions named
* XSP_*_OPTIONS in the file xspi.h.
*
* @note		None.
*
******************************************************************************/
u32 XSpi_GetOptions(XSpi *InstancePtr)
{
	u32 OptionsFlag = 0;
	u32 ControlReg;
	u32 Index;

	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

	/*
	 * Get the control register to determine which options are currently
	 * set.
	 */
	ControlReg = XSpi_GetControlReg(InstancePtr);

	/*
	 * Loop through the options table to determine which options are set.
	 */
	for (Index = 0; Index < XSP_NUM_OPTIONS; Index++) {
		if (ControlReg & OptionsTable[Index].Mask) {
			OptionsFlag |= OptionsTable[Index].Option;
		}
	}

	return OptionsFlag;
}
