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
   use CMSIS.Device.RCC;
with CMSIS.Device.RCC.Instances;
   use CMSIS.Device.RCC.Instances;

package body LL.RCC is
   --  Reset and Clock Control (RCC) low-level driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_rcc.h
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_rcc.c

   RCC renames CMSIS.Device.RCC.Instances.RCC;
   --  Force RCC to represent the instance instead of this child package

   ---------------------------------------------------------------------------
   procedure HSE_Enable_Bypass is
   begin

      RCC.CR.HSEBYP := CR_HSEBYP_Field (2#1#);

   end HSE_Enable_Bypass;

   ---------------------------------------------------------------------------
   procedure HSE_Disable_Bypass is
   begin

      RCC.CR.HSEBYP := CR_HSEBYP_Field (2#0#);

   end HSE_Disable_Bypass;

   ---------------------------------------------------------------------------
   procedure HSE_Enable is
   begin

      RCC.CR.HSEON := CR_HSEON_Field (2#1#);

   end HSE_Enable;

   ---------------------------------------------------------------------------
   procedure HSE_Disable is
   begin

      RCC.CR.HSEON := CR_HSEON_Field (2#0#);

   end HSE_Disable;

   ---------------------------------------------------------------------------
   function HSE_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CR.HSERDY));

   ---------------------------------------------------------------------------
   procedure Set_RTC_HSE_Prescaler (HSE_Prescaler : HSE_Prescaler_Type) is
   begin

      RCC.CR.RTCPRE := CR_RTCPRE_Field (
         HSE_Prescaler_Type'Pos (HSE_Prescaler));

   end Set_RTC_HSE_Prescaler;

   ---------------------------------------------------------------------------
   function Get_RTC_HSE_Prescaler
      return HSE_Prescaler_Type is
      (HSE_Prescaler_Type'Val (RCC.CR.RTCPRE));

   ---------------------------------------------------------------------------
   procedure HSI_Enable is
   begin

      RCC.CR.HSI16ON := CR_HSI16ON_Field (2#1#);

   end HSI_Enable;

   ---------------------------------------------------------------------------
   procedure HSI_Disable is
   begin

      RCC.CR.HSI16ON := CR_HSI16ON_Field (2#0#);

   end HSI_Disable;

   ---------------------------------------------------------------------------
   function HSI_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CR.HSI16RDYF));

   ---------------------------------------------------------------------------
   procedure HSI_Enable_In_Stop_Mode is
   begin

      RCC.CR.HSI16KERON := CR_HSI16KERON_Field (2#1#);

   end HSI_Enable_In_Stop_Mode;

   ---------------------------------------------------------------------------
   procedure HSI_Disable_In_Stop_Mode is
   begin

      RCC.CR.HSI16KERON := CR_HSI16KERON_Field (2#0#);

   end HSI_Disable_In_Stop_Mode;

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Divider is
   begin

      RCC.CR.HSI16DIVEN := CR_HSI16DIVEN_Field (2#1#);

   end HSI_Enable_Divider;

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Divider is
   begin

      RCC.CR.HSI16DIVEN := CR_HSI16DIVEN_Field (2#0#);

   end HSI_Disable_Divider;

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Output is
   begin

      RCC.CR.HSI16OUTEN := CR_HSI16OUTEN_Field (2#1#);

   end HSI_Enable_Output;

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Output is
   begin

      RCC.CR.HSI16OUTEN := CR_HSI16OUTEN_Field (2#0#);

   end HSI_Disable_Output;

   ---------------------------------------------------------------------------
   function HSI_Get_Calibration
      return Natural is
      (Natural (RCC.ICSCR.HSI16CAL));

   ---------------------------------------------------------------------------
   procedure HSI_Set_Calibration_Trimming (
      Value : HSI_Trim_Calibration_Type) is
   begin

      RCC.ICSCR.HSI16TRIM := Value;

   end HSI_Set_Calibration_Trimming;

   ---------------------------------------------------------------------------
   function HSI_Set_Calibration_Trimming
      return Natural is
      (Natural (RCC.ICSCR.HSI16TRIM));

   ---------------------------------------------------------------------------
   procedure LSE_Enable is
   begin

      RCC.CSR.LSEON := CSR_LSEON_Field (2#1#);

   end LSE_Enable;

   ---------------------------------------------------------------------------
   procedure LSE_Disable is
   begin

      RCC.CSR.LSEON := CSR_LSEON_Field (2#0#);

   end LSE_Disable;

   ---------------------------------------------------------------------------
   procedure LSE_Enable_Bypass is
   begin

      RCC.CSR.LSEBYP := CSR_LSEBYP_Field (2#1#);

   end LSE_Enable_Bypass;

   ---------------------------------------------------------------------------
   procedure LSE_Disable_Bypass is
   begin

      RCC.CSR.LSEBYP := CSR_LSEBYP_Field (2#0#);

   end LSE_Disable_Bypass;

   ---------------------------------------------------------------------------
   procedure LSE_Set_Drive_Capability (Value : LSE_Drive_Type) is
   begin

      RCC.CSR.LSEDRV := CSR_LSEDRV_Field (LSE_Drive_Type'Pos (Value));

   end LSE_Set_Drive_Capability;

   ---------------------------------------------------------------------------
   function LSE_Get_Drive_Capability
      return LSE_Drive_Type is
      (LSE_Drive_Type'Val (RCC.CSR.LSEDRV));

   ---------------------------------------------------------------------------
   procedure LSE_Enable_CSS is
   begin

      RCC.CSR.CSSLSEON := CSR_CSSLSEON_Field (2#1#);

   end LSE_Enable_CSS;

   ---------------------------------------------------------------------------
   procedure LSE_Disable_CSS is
   begin

      RCC.CSR.CSSLSEON := CSR_CSSLSEON_Field (2#0#);

   end LSE_Disable_CSS;

   ---------------------------------------------------------------------------
   function LSE_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CSR.LSERDY));

   ---------------------------------------------------------------------------
   function LSE_Is_CSS_Detected
      return Boolean is
      (Boolean'Val (RCC.CSR.CSSLSED));

   ---------------------------------------------------------------------------
   procedure LSI_Enable is
   begin

      RCC.CSR.LSION := CSR_LSION_Field (2#1#);

   end LSI_Enable;

   ---------------------------------------------------------------------------
   procedure LSI_Disable is
   begin

      RCC.CSR.LSION := CSR_LSION_Field (2#0#);

   end LSI_Disable;

   ---------------------------------------------------------------------------
   function LSI_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CSR.LSIRDY));

end LL.RCC;