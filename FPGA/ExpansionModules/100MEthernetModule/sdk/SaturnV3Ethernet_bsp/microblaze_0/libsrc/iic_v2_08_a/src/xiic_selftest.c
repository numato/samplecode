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
* @file xiic_selftest.c
*
* Contains selftest functions for the XIic component.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- --- ------- -----------------------------------------------
* 1.01b jhl 03/26/02 repartioned the driver
* 1.01c ecm 12/05/02 new rev
* 1.01c sv  05/09/05 Changed the data being written to the Address/Control
*                    Register and removed the code for testing the
*                    Receive Data Register.
* 1.13a wgr 03/22/07 Converted to new coding style.
* 1.16a ktn 07/17/09 Updated the test to test only Interrupt Registers
*		     as the software reset only resets the interrupt logic
*		     and the Interrupt Registers are set to default values.
* 1.16a ktn 10/16/09 Updated the notes in the XIic_SelfTest() API and
*                    XIIC_RESET macro to mention that the complete IIC core
*                    is Reset on giving a software reset to the IIC core.
*                    Some previous versions of the core only reset the
*                    Interrupt Logic/Registers, please refer to the HW
*                    specification for futher details.
* 2.00a ktn 10/22/09 Converted all register accesses to 32 bit access.
*		     Updated to use the HAL APIs/macros.
*		     Some of the macros have been renamed to remove _m from
*		     the name and some of the macros have been renamed to be
*		     consistent, see the xiic_i.h and xiic_l.h files for further
*		     information
* </pre>
*
****************************************************************************/

/***************************** Include Files *******************************/

#include "xiic.h"
#include "xiic_i.h"

/************************** Constant Definitions ***************************/


/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/


/************************** Function Prototypes ****************************/


/************************** Variable Definitions **************************/


/*****************************************************************************/
/**
*
* Runs a limited self-test on the driver/device. This test does a read/write
* test of the Interrupt Registers There is no loopback capabilities for the
* device such that this test does not send or receive data.
*
* @param	InstancePtr is a pointer to the XIic instance to be worked on.
*
* @return
*		- XST_SUCCESS if no errors are found
*		- XST_FAILURE if errors are found
*
* @note		None.
*
****************************************************************************/
int XIic_SelfTest(XIic *InstancePtr)
{
	int Status = XST_SUCCESS;
	int GlobalIntrStatus;
	u32 IntrEnableStatus;

	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

	/*
	 * Store the Global Interrupt Register and the Interrupt Enable Register
	 * contents.
	 */
	GlobalIntrStatus = XIic_IsIntrGlobalEnabled(InstancePtr->BaseAddress);
	IntrEnableStatus = XIic_ReadIier(InstancePtr->BaseAddress);

	/*
	 * Reset the device so it's in a known state and the default state of
	 * the interrupt registers can be tested.
	 */
	XIic_Reset(InstancePtr);

	if (XIic_IsIntrGlobalEnabled(InstancePtr->BaseAddress)!= 0) {
		Status = XST_FAILURE;
	}

	if (XIic_ReadIier(InstancePtr->BaseAddress)!= 0) {
		Status = XST_FAILURE;
	}

	/*
	 * Test Read/Write to the Interrupt Enable register.
	 */
	XIic_WriteIier(InstancePtr->BaseAddress, XIIC_TX_RX_INTERRUPTS);
	if (XIic_ReadIier(InstancePtr->BaseAddress)!= XIIC_TX_RX_INTERRUPTS) {
		Status = XST_FAILURE;
	}

	/*
	 * Reset device to remove the affects of the previous test.
	 */
	XIic_Reset(InstancePtr);

	/*
	 * Restore the Global Interrupt Register and the Interrupt Enable
	 * Register contents.
	 */
	if (GlobalIntrStatus == TRUE) {
		XIic_IntrGlobalEnable(InstancePtr->BaseAddress);
	}
	XIic_WriteIier(InstancePtr->BaseAddress, IntrEnableStatus);

	return Status;
}
