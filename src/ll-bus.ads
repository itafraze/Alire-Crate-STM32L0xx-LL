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

package LL.BUS is
   --  BUS low-layer driver
   --
   --  Core bus control and peripheral clock activation and deactivation
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_bus.h

   type APB1_GRP1_Peripheral_Type is
      (TIM2, TIM3, TIM6, TIM7, LCD, WWDG, SPI2, USART2, LPUART1, USART4,
         USART5, I2C1, I2C2, USB, CRS, PWR, DAC1, I2C3, LPTIM1);
   --

   type APB1_GRP1_Peripheral_Select_Type is
      array (APB1_GRP1_Peripheral_Type)
      of Boolean
      with Default_Component_Value => False;
   --

   type APB2_GRP1_Peripheral_Type is
      (SYSCFG, TIM21, TIM22, FW, ADC1, SPI1, USART1, DBGMCU);
   --

   type APB2_GRP1_Peripheral_Select_Type is
      array (APB2_GRP1_Peripheral_Type)
      of Boolean
      with Default_Component_Value => False;
   --

   type IOP_GRP1_Peripheral_Type is
      (GPIOA, GPIOB, GPIOC, GPIOD, GPIOE, GPIOH)
      with Default_Value => GPIOA;
   --

   type IOP_GRP1_Peripheral_Select_Type is
      array (IOP_GRP1_Peripheral_Type)
      of Boolean
      with Default_Component_Value => False;
   --

   ---------------------------------------------------------------------------
   procedure APB1_GRP1_Enable_Clock (
      Peripherals : APB1_GRP1_Peripheral_Select_Type);
   --  Enable APB1 peripherals clock
   --
   --  @param Peripherals

   procedure APB2_GRP1_Enable_Clock (
      Peripherals : APB2_GRP1_Peripheral_Select_Type);
   --  Enable APB2 peripherals clock
   --
   --  @param Peripherals

   ---------------------------------------------------------------------------
   procedure IOP_GRP1_EnableClock (
      Peripherals : IOP_GRP1_Peripheral_Select_Type);
   --  Enable IOP peripherals clock
   --
   --  @param Peripherals



end LL.BUS;
