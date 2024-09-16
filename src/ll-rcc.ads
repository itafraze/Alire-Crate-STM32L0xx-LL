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

with CMSIS.Device.RCC;

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

   subtype HSI_Trim_Calibration_Type is
      CMSIS.Device.RCC.ICSCR_HSI16TRIM_Field;
   --  Type of high speed internal clock trimming value

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

   ---------------------------------------------------------------------------
   procedure HSI_Enable
      with Inline;
   --  Enable HSI oscillator

   ---------------------------------------------------------------------------
   procedure HSI_Disable
      with Inline;
   --  Disable HSI oscillator

   ---------------------------------------------------------------------------
   function HSI_Is_Ready
      return Boolean
      with Inline;
   --  Check if HSI oscillator ready

   ---------------------------------------------------------------------------
   procedure HSI_Enable_In_Stop_Mode
      with Inline;
   --  Enable HSI even in stop mode

   ---------------------------------------------------------------------------
   procedure HSI_Disable_In_Stop_Mode
      with Inline;
   --  Disable HSI in stop mode

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Divider
      with Inline;
   --  Enable HSI divider (it divides by 4)

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Divider
      with Inline;
   --  Disable HSI divider (it divides by 4)

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Output
      with Inline;
   --  Enable HSI output

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Output
      with Inline;
   --  Disable HSI output

   ---------------------------------------------------------------------------
   function HSI_Get_Calibration
      return Natural
      with Inline;
   --  Get HSI calibration value
   --
   --  Notes:
   --  - When HSITRIM is written, HSICAL is updated with the sum of HSITRIM and
   --    the factory trim value

   ---------------------------------------------------------------------------
   procedure HSI_Set_Calibration_Trimming (Value : HSI_Trim_Calibration_Type)
      with Inline;
   --  Set HSI calibration trimming
   --
   --  Notes:
   --  - User-programmable trimming value that is added to the HSICAL
   --  - Default value is 16, which, when added to the HSICAL value, should
   --    trim the HSI to 16 MHz +/- 1 %
   --
   --  TODO:
   --  - Replace HSI_Trim_Calibration_Type with Natural and add precondition
   --    on Value allowed range

   ---------------------------------------------------------------------------
   function HSI_Set_Calibration_Trimming
      return Natural
      with Inline;
   --  Get HSI calibration trimming

   ---------------------------------------------------------------------------
   procedure HSI48_Enable is null
      with Inline;
   --  Enable HSI48
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure HSI48_Disable is null
      with Inline;
   --  Disable HSI48
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function HSI48_Is_Ready
      return Boolean is (False)
      with Inline;
   --  Check if HSI48 oscillator ready
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function HSI48_Get_Calibration
      return Natural is (0)
      with Inline;

   ---------------------------------------------------------------------------
   procedure HSI48_Enable_Divider is null
      with Inline;
   --  Enable HSI48 divider (it divides by 6)
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure HSI48_Disable_Divider is null
      with Inline;
   --  Disable HSI48 divider (it divides by 6)
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function HSI48_Is_Divided
      return Boolean is (False)
      with Inline;
   --  Check if HSI48 divider is enabled (it divides by 6)
   --
   --  TODO:
   --  - Implement for supported devices

end LL.RCC;