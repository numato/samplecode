/*
 * Copyright (c) 2010-2013 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

#include "netif/xaxiemacif.h"
#include "lwipopts.h"

XAxiEthernet_Config *xaxiemac_lookup_config(unsigned mac_base)
{
	extern XAxiEthernet_Config XAxiEthernet_ConfigTable[];
	XAxiEthernet_Config *CfgPtr = NULL;
	int i;

	for (i = 0; i < XPAR_XAXIETHERNET_NUM_INSTANCES; i++) {
		if (XAxiEthernet_ConfigTable[i].BaseAddress == mac_base) {
			CfgPtr = &XAxiEthernet_ConfigTable[i];
			break;
		}
	}

	return (CfgPtr);
}

void init_axiemac(xaxiemacif_s *xaxiemac, struct netif *netif)
{
	unsigned mac_address = (unsigned)(netif->state);
	unsigned link_speed = 1000;
	unsigned options;
	XAxiEthernet *xaxiemacp;
	XAxiEthernet_Config *mac_config;

	/* obtain config of this emac */
	mac_config = xaxiemac_lookup_config(mac_address);

	xaxiemacp = &xaxiemac->axi_ethernet;

	XAxiEthernet_CfgInitialize(xaxiemacp, mac_config, mac_config->BaseAddress);

	options = XAxiEthernet_GetOptions(xaxiemacp);
	options |= XAE_FLOW_CONTROL_OPTION;
#ifdef USE_JUMBO_FRAMES
	options |= XAE_JUMBO_OPTION;
#endif
	options |= XAE_TRANSMITTER_ENABLE_OPTION;
	options |= XAE_RECEIVER_ENABLE_OPTION;
	options |= XAE_FCS_STRIP_OPTION;
	options |= XAE_MULTICAST_OPTION;
	XAxiEthernet_SetOptions(xaxiemacp, options);
	XAxiEthernet_ClearOptions(xaxiemacp, ~options);

	/* set mac address */
	XAxiEthernet_SetMacAddress(xaxiemacp, (unsigned char*)(netif->hwaddr));
	link_speed = Phy_Setup(xaxiemacp);
    	XAxiEthernet_SetOperatingSpeed(xaxiemacp, link_speed);

	/* Setting the operating speed of the MAC needs a delay. */
	{
		volatile int wait;
		for (wait=0; wait < 100000; wait++);
		for (wait=0; wait < 100000; wait++);
	}

#ifdef NOTNOW
        /* in a soft temac implementation, we need to explicitly make sure that
         * the RX DCM has been locked. See xps_ll_temac manual for details.
         * This bit is guaranteed to be 1 for hard temac's
         */
        lock_message_printed = 0;
        while (!(XAxiEthernet_ReadReg(xaxiemacp->Config.BaseAddress, XAE_IS_OFFSET)
                    & XAE_INT_RXDCMLOCK_MASK)) {
                int first = 1;
                if (first) {
                        print("Waiting for RX DCM to lock..");
                        first = 0;
                        lock_message_printed = 1;
                }
        }

        if (lock_message_printed)
                print("RX DCM locked.\r\n");
#endif

	/* start the temac */
    	XAxiEthernet_Start(xaxiemacp);

	/* enable MAC interrupts */
	XAxiEthernet_IntEnable(xaxiemacp, XAE_INT_RECV_ERROR_MASK);
}

void xaxiemac_error_handler(XAxiEthernet * Temac)
{
	unsigned Pending;

	Pending = XAxiEthernet_IntPending(Temac);
	XAxiEthernet_IntClear(Temac, Pending);
}
