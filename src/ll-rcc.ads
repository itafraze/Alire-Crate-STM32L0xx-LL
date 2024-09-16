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
--    2024.09 E. Zarfati
--       - First version
--
------------------------------------------------------------------------------

package LL.RCC is
   --  Reset and Clock Control (RCC) low-level driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_rcc.h

   type HSE_Prescaler_Type is
      (DIV_2, DIV_4, DIV_8, DIV_16)
      with Default_Value => DIV_2;
   --  RTC HSE Prescaler type
   --
   --  @enum DIV_2 HSE is divided by 2 for RTC clock
   --  @enum DIV_4 HSE is divided by 4 for RTC clock
   --  @enum DIV_8 HSE is divided by 8 for RTC clock
   --  @enum DIV_16 HSE is divided by 16 for RTC clock

   ---------------------------------------------------------------------------
   procedure HSE_Enable_CSS is null
      with Inline;
   --  Enable the Clock Security System
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure HSE_Enable_Bypass
      with Inline;
   --  Enable HSE external oscillator (HSE Bypass)

   ---------------------------------------------------------------------------
   procedure HSE_Disable_Bypass
      with Inline;
   --  Disable HSE external oscillator (HSE Bypass)

   ---------------------------------------------------------------------------
   procedure HSE_Enable
      with Inline;
   --  Enable HSE crystal oscillator (HSE ON)

   ---------------------------------------------------------------------------
   procedure HSE_Disable
      with Inline;
   --  Disable HSE crystal oscillator (HSE ON)

   ---------------------------------------------------------------------------
   function HSE_Is_Ready
      return Boolean
      with Inline;
   --  Check if HSE oscillator ready

   ---------------------------------------------------------------------------
   procedure Set_RTC_HSE_Prescaler (HSE_Prescaler : HSE_Prescaler_Type);
   --  Configure the RTC prescaler (divider)

   ---------------------------------------------------------------------------
   function Get_RTC_HSE_Prescaler
      return HSE_Prescaler_Type;
   --  Get the RTC prescaler (divider)

end LL.RCC;