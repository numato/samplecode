/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
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

#include <stdio.h>
#include "platform.h"
#include "xspi.h"
#include "xparameters.h"
#include "xil_cache.h"

void print(char *str);

//Set the offset and size of image in SPI flash
#define FLASH_IMAGE_START_ADDRESS 0x500000
#define FLASH_IMAGE_SIZE 0x600000

//Set the address where image will be loaded. This will usually point to
//DDR or SRAM depending on the board architecture. Remember to build
//your application/Linux kernel with this address as base address
#define IMAGE_LOAD_ADDRESS XPAR_LPDDR_S0_AXI_BASEADDR

//Define ID of the SPI peripheral that is connected to the SPI flash
#define SPI_DEVICE_ID XPAR_AXI_SPI_0_DEVICE_ID

void (*imageEntry)();
XSpi Spi;

//This function reads a byte from SPI peripheral
u8 spiReadData()
{
    while(!(XSpi_ReadReg(Spi.BaseAddr, XSP_SR_OFFSET) & 0x02));
    return XSpi_ReadReg(Spi.BaseAddr,XSP_DRR_OFFSET);
}

//This function writes one byte to the SPI peripheral
void spiWriteData(u8 data)
{
    while(XSpi_GetStatusReg(&Spi) & 0x08);
    XSpi_WriteReg(Spi.BaseAddr, XSP_DTR_OFFSET, data);
}

//This function loads the image to the destination (DDR/SRAM) and executes it
int loadAppImage()
{
    XSpi_Config *cfgPtr;
    u8 recBuffer[4];
    u32 i = 0, index = 0, ddrPtr = 0;

    print("Initializing Numato Saturn V3 SPI Image Loader...\n\r");
    print("*** http://numato.com ***\n\r");
    print("\n\r");

    //Lookup SPI peripheral configuration details
    cfgPtr = XSpi_LookupConfig(SPI_DEVICE_ID);
    if (cfgPtr == NULL)
    {
        return XST_DEVICE_NOT_FOUND;
    }

    if(XSpi_CfgInitialize(&Spi, cfgPtr, cfgPtr->BaseAddress) != XST_SUCCESS)
    {
        return XST_FAILURE;
    }

    //Beyond this point we will use only low level APIs in favor of smaller
    //and simpler code.

    //Set up SPI controller. Master, manual slave select. The SPI peripheral
    //is configured with no FIFO
    XSpi_SetControlReg(&Spi, 0x86);

    //Disable interrupts
    XSpi_IntrGlobalDisable(&Spi);

    //Cycle CS to reset the flash to known state
    XSpi_WriteReg(Spi.BaseAddr, XSP_SSR_OFFSET, 0x00);
    XSpi_WriteReg(Spi.BaseAddr, XSP_SSR_OFFSET, 0x01);
    XSpi_WriteReg(Spi.BaseAddr, XSP_SSR_OFFSET, 0x00);

    //Write command 0x0b (fast read) to SPI flash and do a dummy read
    spiWriteData(0x0b);
    spiReadData();

    //Send the address from where the image needs to be loaded.
    //Dummy read after every write as usual
    spiWriteData((FLASH_IMAGE_START_ADDRESS >> 16) & 0xff);
    spiReadData();
    spiWriteData((FLASH_IMAGE_START_ADDRESS >> 8) & 0xff);
    spiReadData();
    spiWriteData((FLASH_IMAGE_START_ADDRESS) & 0xff);
    spiReadData();

    //A dummy write/read as per W25Q128FV datasheet
    spiWriteData(0x00);
    spiReadData();

    print("Loading application image...\n\r");

    for(i=0; i<=FLASH_IMAGE_SIZE; i++)
    {
        //Do a dummy write
        spiWriteData(0x00);

        //Read data back
        recBuffer[index] = spiReadData();
        index++;

        //Write the data to DDR/SRAM four bytes at a time
        if(index >= 4)
        {
            *((u32*)(ddrPtr + IMAGE_LOAD_ADDRESS)) = *((u32*)(&recBuffer));
            ddrPtr += 4;
            index = 0;
        }
    }

    print("Executing application image...\n\r");
    //Invalidate instruction cache to clean up all existing entries
    Xil_ICacheInvalidate();
    //Execute the loaded image
    imageEntry = (void (*)())IMAGE_LOAD_ADDRESS;
    (*imageEntry)();

    //We shouldn't be here
    return 0;
}

int main()
{
    init_platform();
    loadAppImage();
    return 0;
}
