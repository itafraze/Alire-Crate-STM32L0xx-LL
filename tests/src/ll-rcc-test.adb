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

with AUnit.Assertions;
   use AUnit.Assertions;
with AUnit.Test_Caller;

with CMSIS.Device;
   use CMSIS.Device;
with CMSIS.Device.RCC;
   use CMSIS.Device.RCC;

package body LL.RCC.Test is

   package Caller_Zero
      is new AUnit.Test_Caller (Zero_Fixture);
   --

   Result : aliased AUnit.Test_Suites.Test_Suite;
   --  Statically allocated test suite

   ---------------------------------------------------------------------------
   overriding procedure Set_Up (T : in out Zero_Fixture) is
      --
      RCC_Periph_Array : array (1 .. (RCC_Periph'Size / 8 / 4)) of UInt32
         with Address => RCC_Periph'Address;
   begin

      RCC_Periph_Array := [others => 0];

   end Set_Up;

   ---------------------------------------------------------------------------
   function Suite
      return AUnit.Test_Suites.Access_Test_Suite is
      --
      Suite_Prefix_Zero : constant String := "LL.RCC::Zero_Fixture::";
   begin

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "HSE_Enable_Sets_CR_HSEON",
         HSE_Enable_Sets_CR_HSEON'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "HSE_Enable_Bypass_Sets_CR_HSEBYP",
         HSE_Enable_Bypass_Sets_CR_HSEBYP'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "HSE_Is_Ready_Is_False",
         HSE_Is_Ready_Is_False'Access));

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "Set_RTC_HSE_Prescaler_Sets_CR_RTCPRE",
         Set_RTC_HSE_Prescaler_Sets_CR_RTCPRE'Access));

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "HSI_Enable_Sets_CR_HSI16ON",
         HSI_Enable_Sets_CR_HSI16ON'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "HSI_Is_Ready_Is_False",
         HSI_Is_Ready_Is_False'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "HSI_Enable_In_Stop_Mode_Sets_CR_HSI16KERON",
         HSI_Enable_In_Stop_Mode_Sets_CR_HSI16KERON'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero
            & "HSI_Set_Calibration_Trimming_Sets_ICSCR_HSI16TRIM",
         HSI_Set_Calibration_Trimming_Sets_ICSCR_HSI16TRIM'Access));

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "LSE_Enable_Sets_CSR_LSEON",
         LSE_Enable_Sets_CSR_LSEON'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "LSE_Enable_Bypass_Sets_CSR_LSEBYP",
         LSE_Enable_Bypass_Sets_CSR_LSEBYP'Access));

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "LSI_Enable_Sets_CSR_LSION",
         LSI_Enable_Sets_CSR_LSION'Access));

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "MSI_Enable_Sets_CR_MSION",
         MSI_Enable_Sets_CR_MSION'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "MSI_Set_Range_Sets_ICSCR_MSIRANGE",
         MSI_Set_Range_Sets_ICSCR_MSIRANGE'Access));

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "Set_System_Clock_Source_Sets_CFGR_SW",
         Set_System_Clock_Source_Sets_CFGR_SW'Access));
      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "Set_APB1_Prescaler_Sets_CFGR_PPRE1",
         Set_APB1_Prescaler_Sets_CFGR_PPRE1'Access));

      Result.Add_Test (Caller_Zero.Create (
         Suite_Prefix_Zero & "Set_LPUART1_Clock_Source_Sets_CCIPR_LPUART1SEL",
         Set_LPUART1_Clock_Source_Sets_CCIPR_LPUART1SEL'Access));

      return Result'Access;

   end Suite;

   ---------------------------------------------------------------------------
   procedure HSE_Enable_Sets_CR_HSEON (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.HSE_Enable sets RCC.CR.HSEON to 1
   begin

      HSE_Enable;
      Assert (
         RCC_Periph.CR.HSEON = 1,
         "LL.RCC.HSE_Enable did not set RCC's CR.HSEON");

   end HSE_Enable_Sets_CR_HSEON;

   ---------------------------------------------------------------------------
   procedure HSE_Enable_Bypass_Sets_CR_HSEBYP (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.HSE_Enable_Bypass sets RCC.CR.HSEBYP to 1
   begin

      HSE_Enable_Bypass;
      Assert (
         RCC_Periph.CR.HSEBYP = 1,
         "LL.RCC.HSE_Enable_Bypass did not set RCC's CR.HSEBYP");

   end HSE_Enable_Bypass_Sets_CR_HSEBYP;

   ---------------------------------------------------------------------------
   procedure HSE_Is_Ready_Is_False (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.HSE_Is_Ready returns false
   begin

      Assert (
         HSE_Is_Ready = False,
         "LL.RCC.HSE_Is_Ready did not return False");

   end HSE_Is_Ready_Is_False;

   ---------------------------------------------------------------------------
   procedure Set_RTC_HSE_Prescaler_Sets_CR_RTCPRE (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.Set_RTC_HSE_Prescaler sets RCC.CR.RTCPRE
      HSE_Prescaler_Map : constant array (HSE_Prescaler_Type) of Integer := [
         DIV_2 => 2#00#,
         DIV_4 => 2#01#,
         DIV_8 => 2#10#,
         DIV_16 => 2#11#];
   begin

      for Prescaler in HSE_Prescaler_Type
      loop
         Set_RTC_HSE_Prescaler (Prescaler);
         Assert (
            Integer (RCC_Periph.CR.RTCPRE) = HSE_Prescaler_Map (Prescaler),
            "LL.RCC.Set_RTC_HSE_Prescaler did not set RCC's CR.RTCPRE");
      end loop;

   end Set_RTC_HSE_Prescaler_Sets_CR_RTCPRE;

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Sets_CR_HSI16ON (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.HSE_Enable sets RCC.CR.HSI16ON to 1
   begin

      HSI_Enable;
      Assert (
         RCC_Periph.CR.HSI16ON = 1,
         "LL.RCC.HSI_Enable did not set RCC's CR.HSI16ON");

   end HSI_Enable_Sets_CR_HSI16ON;

   ---------------------------------------------------------------------------
   procedure HSI_Is_Ready_Is_False (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.HSI_Is_Ready returns false
   begin

      Assert (
         HSI_Is_Ready = False,
         "LL.RCC.HSI_Is_Ready did not return False");

   end HSI_Is_Ready_Is_False;

   ---------------------------------------------------------------------------
   procedure HSI_Enable_In_Stop_Mode_Sets_CR_HSI16KERON (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.HSI_Enable_In_Stop_Mode sets RCC.CR.HSI16KERON to 1
   begin

      HSI_Enable_In_Stop_Mode;
      Assert (
         RCC_Periph.CR.HSI16KERON = 1,
         "LL.RCC.HSI_Enable_In_Stop_Mode did not set RCC's CR.HSI16KERON");

   end HSI_Enable_In_Stop_Mode_Sets_CR_HSI16KERON;

   ---------------------------------------------------------------------------
   procedure HSI_Set_Calibration_Trimming_Sets_ICSCR_HSI16TRIM (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.HSI_Set_Calibration_Trimming sets RCC.ICSCR.HSI16TRIM
      Values : constant array (1 .. 2) of HSI_Trim_Calibration_Type := [
         HSI_Trim_Calibration_Type'First,
         HSI_Trim_Calibration_Type'Last];
   begin

      for Value of Values
      loop
         HSI_Set_Calibration_Trimming (Value);
         Assert (
            RCC_Periph.ICSCR.HSI16TRIM = Value,
            "LL.RCC.HSI_Set_Calibration_Trimming did not set RCC's"
               & "ICSCR.HSI16TRIM");
      end loop;

   end HSI_Set_Calibration_Trimming_Sets_ICSCR_HSI16TRIM;

   ---------------------------------------------------------------------------
   procedure LSE_Enable_Sets_CSR_LSEON (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.LSE_Enable sets RCC.CSR.LSEON to 1
   begin

      LSE_Enable;
      Assert (
         RCC_Periph.CSR.LSEON = 1,
         "LL.RCC.LSE_Enable did not set RCC's CSR.LSEON");

   end LSE_Enable_Sets_CSR_LSEON;

   ---------------------------------------------------------------------------
   procedure LSE_Enable_Bypass_Sets_CSR_LSEBYP (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.LSE_Enable sets RCC.CSR.LSEON to 1
   begin

      LSE_Enable_Bypass;
      Assert (
         RCC_Periph.CSR.LSEBYP = 1,
         "LL.RCC.LSE_Enable_Bypass did not set RCC's CSR.LSEBYP");

   end LSE_Enable_Bypass_Sets_CSR_LSEBYP;

   ---------------------------------------------------------------------------
   procedure LSI_Enable_Sets_CSR_LSION (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.LSE_Enable sets RCC.CSR.LSION to 1
   begin

      LSI_Enable;
      Assert (
         RCC_Periph.CSR.LSION = 1,
         "LL.RCC.LSI_Enable did not set RCC's CSR.LSION");

   end LSI_Enable_Sets_CSR_LSION;

   ---------------------------------------------------------------------------
   procedure MSI_Enable_Sets_CR_MSION (UNUSED : in out Zero_Fixture) is
      --  LL.RCC.MSI_Enable sets RCC.CR.MSION to 1
   begin

      MSI_Enable;
      Assert (
         RCC_Periph.CR.MSION = 1,
         "LL.RCC.MSI_Enable did not set RCC's CR.MSION");

   end MSI_Enable_Sets_CR_MSION;

   ---------------------------------------------------------------------------
   procedure MSI_Set_Range_Sets_ICSCR_MSIRANGE (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.MSI_Set_Range sets RCC.ICSCR.MSIRANGE
      MSI_Range_Map : constant array (MSI_Range_Type) of Integer := [
         RANGE_0 => 2#000#,
         RANGE_1 => 2#001#,
         RANGE_2 => 2#010#,
         RANGE_3 => 2#011#,
         RANGE_4 => 2#100#,
         RANGE_5 => 2#101#,
         RANGE_6 => 2#110#];
   begin

      for Rng in MSI_Range_Type
      loop
         MSI_Set_Range (Rng);
         Assert (
            Integer (RCC_Periph.ICSCR.MSIRANGE) = MSI_Range_Map (Rng),
            "LL.RCC.MSI_Set_Range did not set RCC's ICSCR.MSIRANGE");
      end loop;

   end MSI_Set_Range_Sets_ICSCR_MSIRANGE;

   ---------------------------------------------------------------------------
   procedure Set_System_Clock_Source_Sets_CFGR_SW (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.MSI_Set_Range sets RCC.CFGR.SW
      Source_Map : constant array (System_Clock_Source_Type) of Integer := [
         MSI => 2#00#,
         HSI => 2#01#,
         HSE => 2#10#,
         PLL => 2#11#];
   begin

      for Source in System_Clock_Source_Type
      loop
         Set_System_Clock_Source (Source);
         Assert (
            Integer (RCC_Periph.CFGR.SW) = Source_Map (Source),
            "LL.RCC.Set_System_Clock_Source did not set RCC's CFGR.SW");
      end loop;

   end Set_System_Clock_Source_Sets_CFGR_SW;

   ---------------------------------------------------------------------------
   procedure Set_APB1_Prescaler_Sets_CFGR_PPRE1 (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.Set_APB1_Prescaler sets RCC.CFGR.PPRE1
      Prescaler_Map : constant array (APB1_Prescaler_Type) of Integer := [
         DIV_1 => 2#000#,
         DIV_2 => 2#100#,
         DIV_4 => 2#101#,
         DIV_8 => 2#110#,
         DIV_16 => 2#111#];
   begin

      for Prescaler in APB1_Prescaler_Type
      loop
         Set_APB1_Prescaler (Prescaler);
         Assert (
            Integer (RCC_Periph.CFGR.PPRE.Arr (1)) = Prescaler_Map (Prescaler),
            "LL.RCC.Set_APB1_Prescaler did not set RCC's CFGR.PPRE1");
      end loop;

   end Set_APB1_Prescaler_Sets_CFGR_PPRE1;

   ---------------------------------------------------------------------------
   procedure Set_LPUART1_Clock_Source_Sets_CCIPR_LPUART1SEL (
      UNUSED : in out Zero_Fixture) is
      --  LL.RCC.Set_APB1_Prescaler sets RCC.CCIPR.LPUART1
      Source_Map : constant array (LPUART1_Source_Type) of Integer := [
         PCLK1 => 2#00#,
         SYSCLK => 2#01#,
         HSI => 2#10#,
         LSE => 2#11#];
   begin

      for Source in LPUART1_Source_Type
      loop
         Set_LPUART1_Clock_Source (Source);
         Assert (
            Integer (RCC_Periph.CCIPR.LPUART1SEL.Val) = Source_Map (Source),
            "LL.RCC.Set_LPUART1_Clock_Source did not set RCC's CCIPR.LPUART1");
      end loop;

   end Set_LPUART1_Clock_Source_Sets_CCIPR_LPUART1SEL;


end LL.RCC.Test;
