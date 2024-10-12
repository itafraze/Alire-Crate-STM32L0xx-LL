------------------------------------------------------------------------------
--  Copyright 2024, Emanuele Zarfati
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
--
------------------------------------------------------------------------------
--
--  Revision History:
--    2024.03 E. Zarfati
--       - First version
--    2024.10 E. Zarfati
--       - Fix IOP_GRP1_Enable_Clock name
--       - Use RCC instance in place of RCC_Periph
--       - Implement AHB1_GRP1_Enable_Clock
--
------------------------------------------------------------------------------

with CMSIS.Device;
with CMSIS.Device.RCC;
   use CMSIS.Device.RCC;
with CMSIS.Device.RCC.Instances;
   use CMSIS.Device.RCC.Instances;

package body LL.BUS is
   --  BUS low-layer driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_bus.h

   ---------------------------------------------------------------------------
   procedure AHB1_GRP1_Enable_Clock (
      Peripherals : AHB1_GRP1_Peripheral_Select_Type) is
   --
   --  TODO:
   --  - Device-category-dependent implementation to handle missing
   --    peripherals
   begin

      for Ph in AHB1_GRP1_Peripheral_Select_Type'Range
      loop
         if Peripherals (Ph) = True
         then
            case Ph is
               when DMA1 => RCC.AHBENR.DMAEN := AHBENR_DMAEN_Field (2#1#);
               when MIF => RCC.AHBENR.MIFEN := AHBENR_MIFEN_Field (2#1#);
               when CRC => RCC.AHBENR.CRCEN := AHBENR_CRCEN_Field (2#1#);
               when TSC => null;
               when RNG => null;
               when CRYP => RCC.AHBENR.CRYPEN := AHBENR_CRYPEN_Field (2#1#);
            end case;
         end if;
      end loop;

   end AHB1_GRP1_Enable_Clock;

   ---------------------------------------------------------------------------
   procedure APB1_GRP1_Enable_Clock (
      Peripherals : APB1_GRP1_Peripheral_Select_Type) is
   --
   --  TODO:
   --  - Device-category-dependent implementation to handle missing
   --    peripherals
      UNUSED_Bit : CMSIS.Device.Bit
         with Volatile;
   begin

      for Ph in APB1_GRP1_Peripheral_Select_Type'Range
      loop
         if Peripherals (Ph) = True
         then
            case Ph is
               when TIM2 =>
                  RCC.APB1ENR.TIM2EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.TIM2EN;
               when TIM3 =>
                  RCC.APB1ENR.TIM3EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.TIM3EN;
               when TIM6 =>
                  RCC.APB1ENR.TIM6EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.TIM6EN;
               when TIM7 =>
                  RCC.APB1ENR.TIM7EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.TIM7EN;
               when LCD => null;
               when WWDG =>
                  RCC.APB1ENR.WWDGEN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.WWDGEN;
               when SPI2 =>
                  RCC.APB1ENR.SPI2EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.SPI2EN;
               when USART2 =>
                  RCC.APB1ENR.USART2EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.USART2EN;
               when LPUART1 =>
                  RCC.APB1ENR.LPUART1EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.LPUART1EN;
               when USART4 =>
                  RCC.APB1ENR.USART4EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.USART4EN;
               when USART5 =>
                  RCC.APB1ENR.USART5EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.USART5EN;
               when I2C1 =>
                  RCC.APB1ENR.I2C1EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.I2C1EN;
               when I2C2 =>
                  RCC.APB1ENR.I2C2EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.I2C2EN;
               when USB => null;
               when CRS => null;
               when PWR =>
                  RCC.APB1ENR.PWREN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.PWREN;
               when DAC1 => null;
               when I2C3 =>
                  RCC.APB1ENR.I2C3EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.I2C3EN;
               when LPTIM1 =>
                  RCC.APB1ENR.LPTIM1EN := 2#1#;
                  UNUSED_Bit := RCC.APB1ENR.LPTIM1EN;
            end case;
         end if;
      end loop;

   end APB1_GRP1_Enable_Clock;

   ---------------------------------------------------------------------------
   procedure APB1_GRP1_Force_Reset (
      Peripherals : APB1_GRP1_Peripheral_Select_Type) is
   --
   --  TODO:
   --  - Device-category-dependent implementation to handle missing
   --    peripherals
   begin

      for Ph in APB1_GRP1_Peripheral_Select_Type'Range
      loop
         if Peripherals (Ph) = True
         then
            case Ph is
               when TIM2 =>
                  RCC.APB1RSTR.TIM2RST := APB1RSTR_TIM2RST_Field (2#1#);
               when TIM3 =>
                  RCC.APB1RSTR.TIM3RST := APB1RSTR_TIM3RST_Field (2#1#);
               when TIM6 =>
                  RCC.APB1RSTR.TIM6RST := APB1RSTR_TIM6RST_Field (2#1#);
               when TIM7 =>
                  RCC.APB1RSTR.TIM7RST := APB1RSTR_TIM7RST_Field (2#1#);
               when LCD => null;
               when WWDG =>
                  RCC.APB1RSTR.WWDGRST := APB1RSTR_WWDGRST_Field (2#1#);
               when SPI2 =>
                  RCC.APB1RSTR.SPI2RST := APB1RSTR_SPI2RST_Field (2#1#);
               when USART2 =>
                  RCC.APB1RSTR.USART2RST := APB1RSTR_USART2RST_Field (2#1#);
               when LPUART1 =>
                  RCC.APB1RSTR.LPUART1RST := APB1RSTR_LPUART1RST_Field (2#1#);
               when USART4 =>
                  RCC.APB1RSTR.USART4RST := APB1RSTR_USART4RST_Field (2#1#);
               when USART5 =>
                  RCC.APB1RSTR.USART5RST := APB1RSTR_USART5RST_Field (2#1#);
               when I2C1 =>
                  RCC.APB1RSTR.I2C1RST := APB1RSTR_I2C1RST_Field (2#1#);
               when I2C2 =>
                  RCC.APB1RSTR.I2C2RST := APB1RSTR_I2C2RST_Field (2#1#);
               when USB => null;
               when CRS => null;
               when PWR =>
                  RCC.APB1RSTR.PWRRST := APB1RSTR_PWRRST_Field (2#1#);
               when DAC1 => null;
               when I2C3 =>
                  RCC.APB1RSTR.I2C3 := APB1RSTR_I2C3_Field (2#1#);
               when LPTIM1 =>
                  RCC.APB1RSTR.LPTIM1RST := APB1RSTR_LPTIM1RST_Field (2#1#);
            end case;
         end if;
      end loop;

   end APB1_GRP1_Force_Reset;

   ---------------------------------------------------------------------------
   procedure APB1_GRP1_Release_Reset (
      Peripherals : APB1_GRP1_Peripheral_Select_Type) is
   --
   --  TODO:
   --  - Device-category-dependent implementation to handle missing
   --    peripherals
   begin

      for Ph in APB1_GRP1_Peripheral_Select_Type'Range
      loop
         if Peripherals (Ph) = True
         then
            case Ph is
               when TIM2 =>
                  RCC.APB1RSTR.TIM2RST := APB1RSTR_TIM2RST_Field (2#0#);
               when TIM3 =>
                  RCC.APB1RSTR.TIM3RST := APB1RSTR_TIM3RST_Field (2#0#);
               when TIM6 =>
                  RCC.APB1RSTR.TIM6RST := APB1RSTR_TIM6RST_Field (2#0#);
               when TIM7 =>
                  RCC.APB1RSTR.TIM7RST := APB1RSTR_TIM7RST_Field (2#0#);
               when LCD => null;
               when WWDG =>
                  RCC.APB1RSTR.WWDGRST := APB1RSTR_WWDGRST_Field (2#0#);
               when SPI2 =>
                  RCC.APB1RSTR.SPI2RST := APB1RSTR_SPI2RST_Field (2#0#);
               when USART2 =>
                  RCC.APB1RSTR.USART2RST := APB1RSTR_USART2RST_Field (2#0#);
               when LPUART1 =>
                  RCC.APB1RSTR.LPUART1RST := APB1RSTR_LPUART1RST_Field (2#0#);
               when USART4 =>
                  RCC.APB1RSTR.USART4RST := APB1RSTR_USART4RST_Field (2#0#);
               when USART5 =>
                  RCC.APB1RSTR.USART5RST := APB1RSTR_USART5RST_Field (2#0#);
               when I2C1 =>
                  RCC.APB1RSTR.I2C1RST := APB1RSTR_I2C1RST_Field (2#0#);
               when I2C2 =>
                  RCC.APB1RSTR.I2C2RST := APB1RSTR_I2C2RST_Field (2#0#);
               when USB => null;
               when CRS => null;
               when PWR =>
                  RCC.APB1RSTR.PWRRST := APB1RSTR_PWRRST_Field (2#0#);
               when DAC1 => null;
               when I2C3 =>
                  RCC.APB1RSTR.I2C3 := APB1RSTR_I2C3_Field (2#0#);
               when LPTIM1 =>
                  RCC.APB1RSTR.LPTIM1RST := APB1RSTR_LPTIM1RST_Field (2#0#);
            end case;
         end if;
      end loop;

   end APB1_GRP1_Release_Reset;

   ---------------------------------------------------------------------------
   procedure APB2_GRP1_Enable_Clock (
      Peripherals : APB2_GRP1_Peripheral_Select_Type) is
   --
   --  TODO:
   --  - Device-category-dependent implementation to handle missing
   --    peripherals
      UNUSED_Bit : CMSIS.Device.Bit
         with Volatile;
   begin

      for Ph in APB2_GRP1_Peripheral_Select_Type'Range
      loop
         if Peripherals (Ph) = True
         then
            case Ph is
               when SYSCFG =>
                  RCC.APB2ENR.SYSCFGEN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.SYSCFGEN;
               when TIM21 =>
                  RCC.APB2ENR.TIM21EN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.TIM21EN;
               when TIM22 =>
                  RCC.APB2ENR.TIM22EN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.TIM22EN;
               when FW =>
                  RCC.APB2ENR.FWEN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.FWEN;
               when ADC1 =>
                  RCC.APB2ENR.ADCEN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.ADCEN;
               when SPI1 =>
                  RCC.APB2ENR.SPI1EN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.SPI1EN;
               when USART1 =>
                  RCC.APB2ENR.USART1EN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.USART1EN;
               when DBGMCU =>
                  RCC.APB2ENR.DBGEN := 2#1#;
                  UNUSED_Bit := RCC.APB2ENR.DBGEN;
            end case;
         end if;
      end loop;

   end APB2_GRP1_Enable_Clock;

   ---------------------------------------------------------------------------
   procedure IOP_GRP1_Enable_Clock (
      Peripherals : IOP_GRP1_Peripheral_Select_Type) is
   --
      UNUSED_Bit : CMSIS.Device.Bit
         with Volatile;
   begin

      for Ph in IOP_GRP1_Peripheral_Select_Type'Range
      loop
         if Peripherals (Ph) = True
         then
            case Ph is
               when GPIOA =>
                  RCC.IOPENR.IOPAEN := 2#1#;
                  UNUSED_Bit := RCC.IOPENR.IOPAEN;
               when GPIOB =>
                  RCC.IOPENR.IOPBEN := 2#1#;
                  UNUSED_Bit := RCC.IOPENR.IOPBEN;
               when GPIOC =>
                  RCC.IOPENR.IOPCEN := 2#1#;
                  UNUSED_Bit := RCC.IOPENR.IOPCEN;
               when GPIOD =>
                  RCC.IOPENR.IOPDEN := 2#1#;
                  UNUSED_Bit := RCC.IOPENR.IOPDEN;
               when GPIOE =>
                  RCC.IOPENR.IOPEEN := 2#1#;
                  UNUSED_Bit := RCC.IOPENR.IOPEEN;
               when GPIOH =>
                  RCC.IOPENR.IOPHEN := 2#1#;
                  UNUSED_Bit := RCC.IOPENR.IOPHEN;
            end case;
         end if;
      end loop;
   end IOP_GRP1_Enable_Clock;

end LL.BUS;
