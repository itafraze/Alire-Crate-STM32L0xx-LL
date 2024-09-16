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

   type LSE_Drive_Type is
      (LOW, MEDIUM_LOW, MEDIUM_HIGH, HIGH)
      with Default_Value => LOW;
   --  Type of the LSE oscillator drive capability
   --
   --  @enum LOW Xtal mode lower driving capability
   --  @enum MEDIUM_LOW Xtal mode medium low driving capability
   --  @enum MEDIUM_HIGH Xtal mode medium high driving capability
   --  @enum HIGH Xtal mode higher driving capability

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

   ---------------------------------------------------------------------------
   procedure LSE_Enable
      with Inline;
   --  Enable  Low Speed External (LSE) crystal

   ---------------------------------------------------------------------------
   procedure LSE_Disable
      with Inline;
   --  Disable  Low Speed External (LSE) crystal

   ---------------------------------------------------------------------------
   procedure LSE_Enable_Bypass
      with Inline;
   --  Enable external clock source (LSE bypass)

   ---------------------------------------------------------------------------
   procedure LSE_Disable_Bypass
      with Inline;
   --  Disable external clock source (LSE bypass)

   ---------------------------------------------------------------------------
   procedure LSE_Set_Drive_Capability (Value : LSE_Drive_Type)
      with Inline;
   --  Set LSE oscillator drive capability
   --
   --  Notes:
   --  - The oscillator is in Xtal mode when it is not in bypass mode
   --  - Once “00” has been written, the content of LSEDRV cannot be changed by
   --    software.

   ---------------------------------------------------------------------------
   function LSE_Get_Drive_Capability
      return LSE_Drive_Type
      with Inline;
   --  Get LSE oscillator drive capability
   --
   --  @return Driving capability of the LSE oscillator.

   ---------------------------------------------------------------------------
   procedure LSE_Enable_CSS
      with Inline;
   --  Enable Clock Security System on LSE

   ---------------------------------------------------------------------------
   procedure LSE_Disable_CSS
      with Inline;
   --  Disable Clock Security System on LSE
   --
   --  Notes:
   --  - lock security system can be disabled only after a LSE failure
   --    detection. In that case it MUST be disabled by software.

   ---------------------------------------------------------------------------
   function LSE_Is_Ready
      return Boolean
      with Inline;
   --  Check if LSE oscillator ready

   ---------------------------------------------------------------------------
   function LSE_Is_CSS_Detected
      return Boolean
      with Inline;
   --  Check if CSS on LSE failure detection

end LL.RCC;