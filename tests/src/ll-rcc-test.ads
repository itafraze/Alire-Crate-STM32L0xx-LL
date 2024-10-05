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

with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

package LL.RCC.Test is

   type Zero_Fixture is
      new AUnit.Test_Fixtures.Test_Fixture with null record;
   --  All RCC peripherals registers set to zero

   ---------------------------------------------------------------------------
   overriding procedure Set_Up (T : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   function Suite
      return AUnit.Test_Suites.Access_Test_Suite;

private

   ---------------------------------------------------------------------------
   procedure HSE_Enable_Sets_CR_HSEON (UNUSED : in out Zero_Fixture);
   procedure HSE_Enable_Bypass_Sets_CR_HSEBYP (UNUSED : in out Zero_Fixture);
   procedure HSE_Is_Ready_Is_False (UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   procedure Set_RTC_HSE_Prescaler_Sets_CR_RTCPRE (
      UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Sets_CR_HSI16ON (UNUSED : in out Zero_Fixture);
   procedure HSI_Is_Ready_Is_False (UNUSED : in out Zero_Fixture);
   procedure HSI_Enable_In_Stop_Mode_Sets_CR_HSI16KERON (
      UNUSED : in out Zero_Fixture);
   procedure HSI_Set_Calibration_Trimming_Sets_ICSCR_HSI16TRIM (
      UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   procedure LSE_Enable_Sets_CSR_LSEON (UNUSED : in out Zero_Fixture);
   procedure LSE_Enable_Bypass_Sets_CSR_LSEBYP (UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   procedure LSI_Enable_Sets_CSR_LSION (UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   procedure MSI_Enable_Sets_CR_MSION (UNUSED : in out Zero_Fixture);
   procedure MSI_Set_Range_Sets_ICSCR_MSIRANGE (UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   procedure Set_System_Clock_Source_Sets_CFGR_SW (
      UNUSED : in out Zero_Fixture);
   procedure Set_APB1_Prescaler_Sets_CFGR_PPRE1 (UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   procedure Set_LPUART1_Clock_Source_Sets_CCIPR_LPUART1SEL (
      UNUSED : in out Zero_Fixture);

end LL.RCC.Test;
