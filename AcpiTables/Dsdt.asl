/** @file
  Differentiated System Description Table Fields (DSDT)

  Copyright (c) 2014-2015, ARM Ltd. All rights reserved.<BR>
    This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include "Bcm2836.h"
#include "ArmPlatform.h"

DefinitionBlock("DsdtTable.aml", "DSDT", 1, "ARMLTD", "ARM-JUNO", EFI_ACPI_ARM_OEM_REVISION) {
  Scope(_SB) {
    //
    // A57x2-A53x4 Processor declaration
    //
    Device(CPU0) { // A53-0: Cluster 1, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 0)
    }
    Device(CPU1) { // A53-1: Cluster 1, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 1)
    }
    Device(CPU2) { // A53-2: Cluster 1, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 2)
    }
    Device(CPU3) { // A53-3: Cluster 1, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 3)
    }
	
	
	
	        Device (PWM0) {
        
            Name(_HID, "BCM2844")
            Name(_UID, 0)
            Method(_STA)
            {
                Return(0xf)
            }
            Method (_CRS, 0x0, Serialized){
                Name (RBUF, ResourceTemplate (){
                    // DMA channel 11 control
                    Memory32Fixed(ReadWrite, 0x3F007B00, 0x00000100,)
                    // PWM control
                    Memory32Fixed (ReadWrite, 0x3F20C000, 0x00000028,)
                    // PWM control bus
                    Memory32Fixed (ReadWrite, 0x7E20C000, 0x00000028,)
                    // PWM control uncached
                    Memory32Fixed (ReadWrite, 0xFF20C000, 0x00000028,)
                    // PWM clock control
                    Memory32Fixed (ReadWrite, 0x3F1010A0, 0x00000008,)
                    // Interrupt DMA channel 11
                    Interrupt(ResourceConsumer, Level, ActiveHigh, Exclusive) { 0x3B }
                    // DMA channel 11, DREQ 5 for PWM
                    FixedDMA(5, 11, Width32Bit, )
                })
                Return (RBUF)
            }
        }

        //
        // Description: Boot Volume Sentinel Driver
        //

        Device (DSEN) {
        
            Name(_HID, "DSN3832")
            Name(_UID, 0)
            Method(_STA)
            {
                Return(0xf)
            }
        }
	
    // UART PL011
    Device(COM0) {
      Name(_HID, "ARMH0011")
      Name(_CID, "PL011")
      Name(_UID, Zero)
      Name(_CRS, ResourceTemplate() {
        Memory32Fixed(ReadWrite, 0x7FF80000, 0x1000)
        Interrupt(ResourceConsumer, Level, ActiveHigh, Exclusive) { 115 }
      })
    }
	
	
	

    //
    // USB Host Controller
    //
    Device(USB0){
        Name(_HID, "BCM2848")
        Name(_CID, "DWC_OTG")
        Name(_UID, 0)

        Method(_CRS, 0x0, Serialized){
            Name(RBUF, ResourceTemplate(){
                Memory32Fixed(ReadWrite, 0x3F980000, 0x1000)
                Interrupt(ResourceConsumer, Level, ActiveHigh, Exclusive) {0x29} 
            })
            Return(RBUF)
        }
    } // USB0
  } // Scope(_SB)
}
