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

with CMSIS.Device;
   use CMSIS.Device;

with Stm32l0xx_Ll_Config;

package body LL.RCC.LPTIM is
   --  Reset and Clock Control (RCC) low-level driver body for the Low-Power
   --  Timer (LPTIM) peripherals
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_rcc.h
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_rcc.c

   ---------------------------------------------------------------------------
   procedure Set_Clock_Source (Source : LPTIMx_Source_Type) is
   begin

      case Source is
         when LPTIM1_Source_Type'Range =>
            RCC.CCIPR.LPTIM1SEL.Val :=
               LPTIMx_Source_Type'Pos (Source)
               - LPTIMx_Source_Type'Pos (LPTIM1_Source_Type'First);
      end case;

   end Set_Clock_Source;

   ---------------------------------------------------------------------------
   function Get_Clock_Source (Instance : LPTIM_Instance_Type)
      return LPTIMx_Source_Type is
      --
      Source : LPTIMx_Source_Type;
   begin

      Source := LPTIMx_Source_Type'Val (case Instance is
         when LPTIM1 =>
            RCC.CCIPR.LPTIM1SEL.Val
            + LPTIM1_Source_Type'Pos (LPTIM1_Source_Type'First));

      return Source;

   end Get_Clock_Source;

   ---------------------------------------------------------------------------
   function Get_Clock_Frequency (Instance : LPTIM_Instance_Type)
      return Natural is
      --
      Frequency : Natural := 0;
   begin

      case Get_Clock_Source (Instance) is
         when LPTIM1_PCLK1 => null;
            Frequency :=
               Get_PCLK1_Clock_Frequency (
                  Get_HCLK_Clock_Frequency (
                     Get_System_Clock_Frequency));

         when LPTIM1_LSI =>
            if LSI_Is_Ready
            then
               Frequency := LSI_Frequency;
            end if;

         when LPTIM1_HSI =>
            if HSI_Is_Ready
            then
               Frequency := Natural (
                  Shift_Right (
                     UInt32 (HSI_Frequency),
                     (Boolean'Pos (Is_Active_Flag_HSIDIV) * 2)));
            end if;

         when LPTIM1_LSE =>
            if LSE_Is_Ready
            then
               Frequency := Stm32l0xx_Ll_Config.LSE_Frequency;
            end if;
      end case;

      return Frequency;

   end Get_Clock_Frequency;

end LL.RCC.LPTIM;