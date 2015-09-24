/******************************************************************************
*
* (c) Copyright 2004-2013 Xilinx, Inc. All rights reserved.
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
* @file xemaclite_selftest.c
*
* Function(s) in this file are the required functions for the EMAC Lite
* driver sefftest for the hardware.
* See xemaclite.h for a detailed description of the driver.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- --------------------------------------------------------
* 1.01a ecm  01/31/04 First release
* 1.11a mta  03/21/07 Updated to new coding style
* 3.00a ktn  10/22/09 Updated driver to use the HAL Processor APIs/macros.
* </pre>
******************************************************************************/

/***************************** Include Files *********************************/

#include "xil_io.h"
#include "xemaclite.h"
#include "xemaclite_i.h"

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/

/*****************************************************************************/
/**
*
* Performs a SelfTest on the EmacLite device as follows:
*   - Writes to the mandatory TX buffer and reads back to verify.
*   - If configured, writes to the secondary TX buffer and reads back to verify.
*   - Writes to the mandatory RX buffer and reads back to verify.
*   - If configured, writes to the secondary RX buffer and reads back to verify.
*
*
* @param	InstancePtr is a pointer to the XEmacLite instance .
*
* @return
*		- XST_SUCCESS if the device Passed the Self Test.
* 		- XST_FAILURE if any of the data read backs fail.
*
* @note		None.
*
******************************************************************************/
int XEmacLite_SelfTest(XEmacLite * InstancePtr)
{
	u32 BaseAddress;
	u8 Index;
	u8 TestString[4] = { 0xDE, 0xAD, 0xBE, 0xEF };
	u8 ReturnString[4] = { 0x0, 0x0, 0x0, 0x0 };

	/*
	 * Verify that each of the inputs are valid.
	 */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/*
	 * Determine the TX buffer address
	 */
	BaseAddress = InstancePtr->EmacLiteConfig.BaseAddress +
			XEL_TXBUFF_OFFSET;

	/*
	 * Write the TestString to the TX buffer in EMAC Lite then
	 * back from the EMAC Lite and verify
	 */
	XEmacLite_AlignedWrite(TestString, (u32 *) BaseAddress,
			       sizeof(TestString));
	XEmacLite_AlignedRead((u32 *) BaseAddress, ReturnString,
			      sizeof(ReturnString));

	for (Index = 0; Index < 4; Index++) {

		if (ReturnString[Index] != TestString[Index]) {
			return XST_FAILURE;
		}

		/*
		 * Zero the return string for the next test
		 */
		ReturnString[Index] = 0;
	}

	/*
	 * If the second buffer is configured, test it also
	 */
	if (InstancePtr->EmacLiteConfig.TxPingPong != 0) {
		BaseAddress += XEL_BUFFER_OFFSET;
		/*
		 * Write the TestString to the optional TX buffer in EMAC Lite
		 * then back from the EMAC Lite and verify
		 */
		XEmacLite_AlignedWrite(TestString, (u32 *) BaseAddress,
				       sizeof(TestString));
		XEmacLite_AlignedRead((u32 *) BaseAddress, ReturnString,
				      sizeof(ReturnString));

		for (Index = 0; Index < 4; Index++) {

			if (ReturnString[Index] != TestString[Index]) {
				return XST_FAILURE;
			}

			/*
			 * Zero the return string for the next test
			 */
			ReturnString[Index] = 0;
		}
	}

	/*
	 * Determine the RX buffer address
	 */
	BaseAddress = InstancePtr->EmacLiteConfig.BaseAddress +
				XEL_RXBUFF_OFFSET;

	/*
	 * Write the TestString to the RX buffer in EMAC Lite then
	 * back from the EMAC Lite and verify
	 */
	XEmacLite_AlignedWrite(TestString, (u32 *) (BaseAddress),
			       sizeof(TestString));
	XEmacLite_AlignedRead((u32 *) (BaseAddress), ReturnString,
			      sizeof(ReturnString));

	for (Index = 0; Index < 4; Index++) {

		if (ReturnString[Index] != TestString[Index]) {
			return XST_FAILURE;
		}

		/*
		 * Zero the return string for the next test
		 */
		ReturnString[Index] = 0;
	}

	/*
	 * If the second buffer is configured, test it also
	 */
	if (InstancePtr->EmacLiteConfig.RxPingPong != 0) {
		BaseAddress += XEL_BUFFER_OFFSET;
		/*
		 * Write the TestString to the optional RX buffer in EMAC Lite
		 * then back from the EMAC Lite and verify
		 */
		XEmacLite_AlignedWrite(TestString, (u32 *) BaseAddress,
				       sizeof(TestString));
		XEmacLite_AlignedRead((u32 *) BaseAddress, ReturnString,
				      sizeof(ReturnString));

		for (Index = 0; Index < 4; Index++) {

			if (ReturnString[Index] != TestString[Index]) {
				return XST_FAILURE;
			}

			/*
			 * Zero the return string for the next test
			 */
			ReturnString[Index] = 0;
		}
	}

	return XST_SUCCESS;
}
