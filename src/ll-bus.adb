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
--
------------------------------------------------------------------------------

with CMSIS.Device;
with CMSIS.Device.RCC;
   use CMSIS.Device.RCC;

package body LL.BUS is
   --  BUS low-layer driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_bus.h

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
                  RCC_Periph.APB1ENR.TIM2EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.TIM2EN;
               when TIM3 =>
                  RCC_Periph.APB1ENR.TIM3EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.TIM3EN;
               when TIM6 =>
                  RCC_Periph.APB1ENR.TIM6EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.TIM6EN;
               when TIM7 =>
                  RCC_Periph.APB1ENR.TIM7EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.TIM7EN;
               when LCD => null;
               when WWDG =>
                  RCC_Periph.APB1ENR.WWDGEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.WWDGEN;
               when SPI2 =>
                  RCC_Periph.APB1ENR.SPI2EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.SPI2EN;
               when USART2 =>
                  RCC_Periph.APB1ENR.USART2EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.USART2EN;
               when LPUART1 =>
                  RCC_Periph.APB1ENR.LPUART1EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.LPUART1EN;
               when USART4 =>
                  RCC_Periph.APB1ENR.USART4EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.USART4EN;
               when USART5 =>
                  RCC_Periph.APB1ENR.USART5EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.USART5EN;
               when I2C1 =>
                  RCC_Periph.APB1ENR.I2C1EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.I2C1EN;
               when I2C2 =>
                  RCC_Periph.APB1ENR.I2C2EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.I2C2EN;
               when USB => null;
               when CRS => null;
               when PWR =>
                  RCC_Periph.APB1ENR.PWREN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.PWREN;
               when DAC1 => null;
               when I2C3 =>
                  RCC_Periph.APB1ENR.I2C3EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.I2C3EN;
               when LPTIM1 =>
                  RCC_Periph.APB1ENR.LPTIM1EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB1ENR.LPTIM1EN;
            end case;
         end if;
      end loop;

   end APB1_GRP1_Enable_Clock;


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
                  RCC_Periph.APB2ENR.SYSCFGEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.SYSCFGEN;
               when TIM21 =>
                  RCC_Periph.APB2ENR.TIM21EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.TIM21EN;
               when TIM22 =>
                  RCC_Periph.APB2ENR.TIM22EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.TIM22EN;
               when FW =>
                  RCC_Periph.APB2ENR.FWEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.FWEN;
               when ADC1 =>
                  RCC_Periph.APB2ENR.ADCEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.ADCEN;
               when SPI1 =>
                  RCC_Periph.APB2ENR.SPI1EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.SPI1EN;
               when USART1 =>
                  RCC_Periph.APB2ENR.USART1EN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.USART1EN;
               when DBGMCU =>
                  RCC_Periph.APB2ENR.DBGEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.APB2ENR.DBGEN;
            end case;
         end if;
      end loop;

   end APB2_GRP1_Enable_Clock;

   ---------------------------------------------------------------------------
   procedure IOP_GRP1_EnableClock (
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
                  RCC_Periph.IOPENR.IOPAEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.IOPENR.IOPAEN;
               when GPIOB =>
                  RCC_Periph.IOPENR.IOPBEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.IOPENR.IOPBEN;
               when GPIOC =>
                  RCC_Periph.IOPENR.IOPCEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.IOPENR.IOPCEN;
               when GPIOD =>
                  RCC_Periph.IOPENR.IOPDEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.IOPENR.IOPDEN;
               when GPIOE =>
                  RCC_Periph.IOPENR.IOPEEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.IOPENR.IOPEEN;
               when GPIOH =>
                  RCC_Periph.IOPENR.IOPHEN := 2#1#;
                  UNUSED_Bit := RCC_Periph.IOPENR.IOPHEN;
            end case;
         end if;
      end loop;
   end IOP_GRP1_EnableClock;

end LL.BUS;
