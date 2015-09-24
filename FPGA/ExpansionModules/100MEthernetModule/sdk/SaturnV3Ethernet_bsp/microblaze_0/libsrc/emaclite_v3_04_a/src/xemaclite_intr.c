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
* @file xemaclite_intr.c
*
* Functions in this file are for the interrupt driven processing functionality.
* See xemaclite.h for a detailed description of the driver.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- --------------------------------------------------------
* 1.01a ecm  03/31/04 First release
* 1.11a mta  03/21/07 Updated to new coding style
* 2.01a ktn  07/20/09 Modified the XEmacLite_EnableInterrupts and
*                     XEmacLite_DisableInterrupts functions to enable/disable
*                     the interrupt in the Ping buffer as this is used to enable
*                     the interrupts for both Ping and Pong Buffers.
*                     The interrupt enable bit in the Pong buffer is not used by
*                     the HW.
* 3.00a ktn  10/22/09 Updated file to use the HAL Processor APIs/macros.
*		      The macros have been renamed to remove _m from the name.
*
* </pre>
******************************************************************************/

/***************************** Include Files *********************************/

#include "xemaclite_i.h"
#include "xil_io.h"
#include "xemaclite.h"

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/
/*****************************************************************************/
/**
*
* Enable the EmacLite Interrupts.
*
* This function must be called before other functions to send or receive data
* in interrupt driven mode. The user should have connected the
* interrupt handler of the driver to an interrupt source such as an interrupt
* controller or the processor interrupt prior to this function being called.
*
* @param	InstancePtr is a pointer to the XEmacLite instance.
*
* @return
* 		- XST_SUCCESS if the device interrupts were enabled
*			successfully.
*		- XST_NO_CALLBACK if the callbacks were not set.
*
* @note		None.
*
******************************************************************************/
int XEmacLite_EnableInterrupts(XEmacLite *InstancePtr)
{
	u32 Register;
	u32 BaseAddress;

	/*
	 * Verify that each of the inputs are valid.
	 */
	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

	BaseAddress = InstancePtr->EmacLiteConfig.BaseAddress;

	/*
	 * Verify that the handlers are in place.
	 */
	if ((InstancePtr->RecvHandler == (XEmacLite_Handler) StubHandler) ||
	    (InstancePtr->SendHandler == (XEmacLite_Handler) StubHandler)) {
		return XST_NO_CALLBACK;
	}

	/*
	 * Enable the TX interrupts for both the buffers, the Interrupt Enable
	 * is common for the both the buffers and is defined in the
	 * Ping buffer.
	 */
	Register = XEmacLite_GetTxStatus(BaseAddress);
	Register |= XEL_TSR_XMIT_IE_MASK;
	XEmacLite_SetTxStatus(BaseAddress, Register);

	/*
	 * Enable the RX interrupts for both the buffers, the Interrupt Enable
	 * is common for the both the buffers and is defined in the
	 * Ping buffer.
	 */
	Register = XEmacLite_GetRxStatus(BaseAddress);
	Register |= XEL_RSR_RECV_IE_MASK;
	XEmacLite_SetRxStatus(BaseAddress, Register);

	/*
	 * Enable the global interrupt output.
	 */
	XEmacLite_WriteReg(BaseAddress, XEL_GIER_OFFSET, XEL_GIER_GIE_MASK);

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* Disables the interrupts from the device (the higher layer software is
* responsible for disabling interrupts at the interrupt controller).
*
* To start using the device again, _EnableInterrupts must be called.
*
* @param	InstancePtr is a pointer to the XEmacLite instance .
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XEmacLite_DisableInterrupts(XEmacLite *InstancePtr)
{
	u32 Register;
	u32 BaseAddress;

	/*
	 * Verify that each of the inputs are valid.
	 */
	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);


	BaseAddress = InstancePtr->EmacLiteConfig.BaseAddress;

	/*
	 * Disable the global interrupt output.
	 */
	XEmacLite_WriteReg(BaseAddress, XEL_GIER_OFFSET, 0);

	/*
	 * Disable the TX interrupts for both the buffers, the Interrupt Enable
	 * is common for the both the buffers and is defined in the
	 * Ping buffer.
	 */
	Register = XEmacLite_GetTxStatus(BaseAddress);
	Register &= ~XEL_TSR_XMIT_IE_MASK;
	XEmacLite_SetTxStatus(BaseAddress, Register);

	/*
	 * Disable the RX interrupts for both the buffers, the Interrupt Enable
	 * is common for the both the buffers and is defined in the
	 * Ping buffer.
	 */
	Register = XEmacLite_GetRxStatus(BaseAddress);
	Register &= ~XEL_RSR_RECV_IE_MASK;
	XEmacLite_SetRxStatus(BaseAddress, Register);

}

/*****************************************************************************/
/**
*
* Interrupt handler for the EmacLite driver. It performs the following
* processing:
*
*	- Get the interrupt status from the registers to determine the source
* 	of the interrupt.
* 	- Call the appropriate handler based on the source of the interrupt.
*
* @param	InstancePtr contains a pointer to the EmacLite device instance
*		for the interrupt.
*
* @return	None.
*
* @note		None.
*
*
******************************************************************************/
void XEmacLite_InterruptHandler(void *InstancePtr)
{

	XEmacLite *EmacLitePtr;
	int TxCompleteIntr = FALSE;
	u32 BaseAddress;
	u32 TxStatus;

	/*
	 * Verify that each of the inputs are valid.
	 */
	Xil_AssertVoid(InstancePtr != NULL);

	/*
	 * Convert the non-typed pointer to an EmacLite instance pointer
	 * such that there is access to the device.
	 */
	EmacLitePtr = (XEmacLite *) InstancePtr;
	BaseAddress = EmacLitePtr->EmacLiteConfig.BaseAddress;

	if ((XEmacLite_IsRxEmpty(BaseAddress) != TRUE) ||
		(XEmacLite_IsRxEmpty(BaseAddress +
			XEL_BUFFER_OFFSET) != TRUE)) {
		/*
		 * Call the RX callback.
		 */
		EmacLitePtr->RecvHandler(EmacLitePtr->RecvRef);

	}

	TxStatus = XEmacLite_GetTxStatus(BaseAddress);
	if (((TxStatus & XEL_TSR_XMIT_BUSY_MASK) == 0) &&
		(TxStatus & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {

		/*
		 * Clear the Tx Active bit in the Tx Status Register.
		 */
		TxStatus &= ~XEL_TSR_XMIT_ACTIVE_MASK;
		XEmacLite_SetTxStatus(BaseAddress, TxStatus);

		/*
		 * Update the flag indicating that there was a Tx Interrupt.
		 */
		TxCompleteIntr = TRUE;

	}

	TxStatus = XEmacLite_GetTxStatus(BaseAddress + XEL_BUFFER_OFFSET);
	if (((TxStatus & XEL_TSR_XMIT_BUSY_MASK) == 0) &&
		(TxStatus & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {

		/*
		 * Clear the Tx Active bit in the Tx Status Register.
		 */
		TxStatus &= ~XEL_TSR_XMIT_ACTIVE_MASK;
		XEmacLite_SetTxStatus(BaseAddress + XEL_BUFFER_OFFSET,
					TxStatus);
		/*
		 * Update the flag indicating that there was a Tx Interrupt.
		 */
		TxCompleteIntr = TRUE;
	}

	/*
	 * If there was a TX interrupt, call the callback.
	 */
	if (TxCompleteIntr == TRUE) {

		/*
		 * Call the TX callback.
		 */
		EmacLitePtr->SendHandler(EmacLitePtr->SendRef);

	}
}

/*****************************************************************************/
/**
*
* Sets the callback function for handling received frames in interrupt mode.
* The upper layer software should call this function during initialization.
* The callback is called when a frame is received. The callback function
* should communicate the data to a thread such that the processing is not
* performed in an interrupt context.
*
* The callback is invoked by the driver within interrupt context, so it needs
* to do its job quickly. If there are other potentially slow operations
* within the callback, these should be done at task-level.
*
* @param	InstancePtr is a pointer to the XEmacLite instance..
* @param	CallBackRef is a reference pointer to be passed back to the
*		application in the callback. This helps the application
*		correlate the callback to a particular driver.
* @param	FuncPtr is the pointer to the callback function.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XEmacLite_SetRecvHandler(XEmacLite *InstancePtr, void *CallBackRef,
			      XEmacLite_Handler FuncPtr)
{
	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(FuncPtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

	InstancePtr->RecvHandler = FuncPtr;
	InstancePtr->RecvRef = CallBackRef;
}


/*****************************************************************************/
/**
*
* Sets the callback function for handling transmitted frames in interrupt mode.
* The upper layer software should call this function during initialization.
* The callback is called when a frame is transmitted. The callback function
* should communicate the data to a thread such that the processing is not
* performed in an interrupt context.
*
* The callback is invoked by the driver within interrupt context, so it needs
* to do its job quickly. If there are other potentially slow operations
* within the callback, these should be done at task-level.
*
* @param	InstancePtr is a pointer to the XEmacLite instance.
* @param	CallBackRef is a reference pointer to be passed back to the
*		application in the callback. This helps the application
*		correlate the callback to a particular driver.
* @param	FuncPtr is the pointer to the callback function.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XEmacLite_SetSendHandler(XEmacLite *InstancePtr, void *CallBackRef,
			      XEmacLite_Handler FuncPtr)
{
	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(FuncPtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

	InstancePtr->SendHandler = FuncPtr;
	InstancePtr->SendRef = CallBackRef;
}
