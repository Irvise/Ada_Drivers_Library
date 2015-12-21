------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2015, AdaCore                           --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of STMicroelectronics nor the names of its       --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
--                                                                          --
--  This file is based on:                                                  --
--                                                                          --
--   @file    stm32f429i_discovery.h                                        --
--   @author  MCD Application Team                                          --
--   @version V1.1.0                                                        --
--   @date    19-June-2014                                                  --
--   @brief   This file contains definitions for STM32F429I-Discovery Kit   --
--            LEDs, push-buttons hardware resources.                        --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

--  This file provides declarations for devices on the STM32F429 Discovery kits
--  manufactured by ST Microelectronics.

with STM32.Device;  use STM32.Device;

with STM32.GPIO;    use STM32.GPIO;
with STM32.SPI;     use STM32.SPI;
with STM32.ADC;     use STM32.ADC;
with STM32.L3DG20;  use STM32.L3DG20;
with STM32.FMC;     use STM32.FMC;

with Ada.Interrupts.Names;  use Ada.Interrupts;

use STM32;  -- for base addresses

package STM32.Board is

   pragma Elaborate_Body;

   subtype User_LED is GPIO_Point;

   Green : User_LED renames PG13;
   Red   : User_LED renames PG14;

   LED3    : User_LED renames Green;
   LED4    : User_LED renames Red;
   LCH_LED : User_LED renames Red;

   All_LEDs  : constant GPIO_Points := LED3 & LED4;

   procedure Initialize_LEDs;
   --  MUST be called prior to any use of the LEDs

   procedure Turn_On (This : User_LED)
     renames STM32.GPIO.Set;
   procedure Turn_Off (This : User_LED)
     renames STM32.GPIO.Clear;

   procedure All_LEDs_Off with Inline;
   procedure All_LEDs_On  with Inline;
   procedure Toggle_LEDs (These : GPIO_Points)
     renames STM32.GPIO.Toggle;

   Gyro : Three_Axis_Gyroscope;

   --  GPIO Pins for FMC

   FMC_D : constant GPIO_Points :=
             (PD14, PD15, PD0, PD1, PE7, PE8, PE9, PE10,
              PE11, PE12, PE13, PE14, PE15, PD8, PD9, PD10);

   FMC_A : constant GPIO_Points :=
              (PF0, PF1, PF2, PF3, PF4, PF5,
               PF12, PF13, PF14, PF15, PG0, PG1);

   FMC_SDNWE  : GPIO_Point renames PC0;
   FMC_SDNRAS : GPIO_Point renames PF11;
   FMC_SDNCAS : GPIO_Point renames PG15;
   FMC_SDCLK  : GPIO_Point renames PG8;
   FMC_BA0    : GPIO_Point renames PG4;
   FMC_BA1    : GPIO_Point renames PG5;
   FMC_NBL0   : GPIO_Point renames PE0;
   FMC_NBL1   : GPIO_Point renames PE1;
   FMC_SDNE1  : GPIO_Point renames PB6;
   FMC_SDCKE1 : GPIO_Point renames PB5;

   SDRAM_PINS    : constant GPIO_Points :=
                     FMC_A & FMC_D &
                     FMC_SDNWE & FMC_SDNRAS & FMC_SDNCAS & FMC_SDCLK &
                     FMC_BA0 & FMC_BA1 & FMC_SDNE1 & FMC_SDCKE1 &
                     FMC_NBL0 & FMC_NBL1;

   --  SDRAM CONFIGURATION Parameters
   SDRAM_Base         : constant := 16#D0000000#;
   SDRAM_Size         : constant := 16#800000#;
   SDRAM_Bank         : constant STM32.FMC.FMC_SDRAM_Cmd_Target_Bank :=
                          STM32.FMC.FMC_Bank2_SDRAM;
   SDRAM_Mem_Width    : constant STM32.FMC.FMC_SDRAM_Memory_Bus_Width :=
                          STM32.FMC.FMC_SDMemory_Width_16b;
   SDRAM_CAS_Latency  : constant STM32.FMC.FMC_SDRAM_CAS_Latency :=
                          STM32.FMC.FMC_CAS_Latency_3;
   SDRAM_CLOCK_Period : constant STM32.FMC.FMC_SDRAM_Clock_Configuration :=
                          STM32.FMC.FMC_SDClock_Period_2;
   SDRAM_Read_Burst   : constant STM32.FMC.FMC_SDRAM_Burst_Read :=
                          STM32.FMC.FMC_Read_Burst_Disable;
   SDRAM_Read_Pipe    : constant STM32.FMC.FMC_SDRAM_Read_Pipe_Delay :=
                          STM32.FMC.FMC_ReadPipe_Delay_1;
   SDRAM_Refresh_Cnt  : constant := 1386;

   ---------------
   -- SPI5 Pins --
   ---------------

   SPI5_SCK     : GPIO_Point renames PF7;
   SPI5_MISO    : GPIO_Point renames PF8;
   SPI5_MOSI    : GPIO_Point renames PF9;
   NCS_MEMS_SPI : GPIO_Point renames PC1;
   MEMS_INT1    : GPIO_Point renames PA1;
   MEMS_INT2    : GPIO_Point renames PA2;
   LCD_SPI      : SPI_Port   renames SPI_5;

   ------------------------
   --  GPIO Pins for LCD --
   ------------------------

   --  See the STM32F429I-Discovery board schematics for the actual pin
   --  assignments

   --  Chip select and Data/Command select fot the LCD screen
   LCD_CSX      : GPIO_Point renames PC2;
   LCD_WRX_DCX  : GPIO_Point renames PD13;
   LCD_RESET    : GPIO_Point renames PD12;

   --  RGB connection
   LCD_VSYNC    : GPIO_Point renames PA4;
   LCD_HSYNC    : GPIO_Point renames PC6;
   LCD_ENABLE   : GPIO_Point renames PF10;
   LCD_CLK      : GPIO_Point renames PG7;

   --  See the STM32F427xx/STM32F429xx datasheet for the aleternate function
   --  mapping.
   LCD_RGB_AF9  : constant GPIO_Points :=
                    (PB0, PB1, PG10, PG12);
   LCD_RGB_AF14 : constant GPIO_Points :=
                    (PC10, PA11, PA12, PG6,
                     PA6, PB10, PB11, PC7, PD3,
                     PD6, PG11, PA3, PB8, PB9);
   LCD_PINS     : constant GPIO_Points :=
                     LCD_RGB_AF14 & LCD_RGB_AF9 &
                     LCD_VSYNC & LCD_HSYNC & LCD_ENABLE & LCD_CLK;

   --  User button

   User_Button_Point     : GPIO_Point renames PA0;
   User_Button_Interrupt : constant Interrupt_Id := Names.EXTI0_Interrupt;

   procedure Configure_User_Button_GPIO;
   --  Configures the GPIO port/pin for the blue user button. Sufficient
   --  for polling the button, and necessary for having the button generate
   --  interrupts.

end STM32.Board;
