##############################################################-*-asm-*- 
#
# Copyright (c) 2004 Xilinx, Inc.  All rights reserved.
#
# Xilinx, Inc.
# XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A 
# COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
# ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR 
# STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
# IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE 
# FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  
# XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO 
# THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO 
# ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE 
# FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY 
# AND FITNESS FOR A PARTICULAR PURPOSE.
# 
# Enable exceptions on microblaze.
#
# $Id: microblaze_enable_exceptions.s,v 1.1.2.1 2011/05/17 04:37:27 sadanan Exp $
#
####################################################################

.section .text
.globl	microblaze_enable_exceptions
.ent	microblaze_enable_exceptions
.align 2
microblaze_enable_exceptions:
        mfs     r4, rmsr;
        ori     r4, r4, 0x100;                  /* Turn ON the EE bit */
        mts     rmsr, r4;
        rtsd    r15, 8;
        nop;        
.end microblaze_enable_exceptions

	
  
