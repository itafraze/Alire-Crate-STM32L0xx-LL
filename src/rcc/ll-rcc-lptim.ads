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

package LL.RCC.LPTIM is
   --  Reset and Clock Control (RCC) low-level driver for the Low-Power Timer
   --  (LPTIM) peripherals
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_rcc.h
   --
   --  TODO:
   --  - Implement API Get_LPTIM_Clock_Frequency

   type LPTIM1_Source_Type is
      (PCLK1, LSI, HSI, LSE)
      with Default_Value => PCLK1;
   --  Type of the LPTIM1 clock source
   --
   --  @enum PCLK1 PCLK1 selected as LPTIM1 clock
   --  @enum LSI LSI selected as LPTIM1 clock
   --  @enum HSI HSI selected as LPTIM1 clock
   --  @enum LSE LSE selected as LPTIM1 clock

   ---------------------------------------------------------------------------
   procedure Set_LPTIM1_Clock_Source (Source : LPTIM1_Source_Type)
      with Inline;
   --  Configure LPTIM1 clock source

   ---------------------------------------------------------------------------
   function Get_LPTIM1_Clock_Source
      return LPTIM1_Source_Type
      with Inline;
   --  Get LPTIM1 clock source

end LL.RCC.LPTIM;