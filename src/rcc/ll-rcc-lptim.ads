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

with CMSIS.Device.LPTIM.Instances;
   use all type CMSIS.Device.LPTIM.Instances.Instance_Type;

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

   subtype LPTIM_Instance_Type is
      CMSIS.Device.LPTIM.Instances.Instance_Type;
   --

   type LPTIMx_Source_Type is
      (LPTIM1_PCLK1, LPTIM1_LSI, LPTIM1_HSI, LPTIM1_LSE)
      with Default_Value => LPTIM1_PCLK1;
   --  Type of the LPTIMx clock source
   --
   --  @enum LPTIM1_PCLK1 PCLK1 selected as LPTIM1 clock
   --  @enum LPTIM1_LSI LSI selected as LPTIM1 clock
   --  @enum LPTIM1_HSI HSI selected as LPTIM1 clock
   --  @enum LPTIM1_LSE LSE selected as LPTIM1 clock

   subtype LPTIM1_Source_Type is
      LPTIMx_Source_Type range LPTIM1_PCLK1 .. LPTIM1_LSE;
   --  Type of the LPTIM1 clock source

   ---------------------------------------------------------------------------
   procedure Set_Clock_Source (Source : LPTIMx_Source_Type)
      with Inline;
   --  Configure LPTIMx clock source

   ---------------------------------------------------------------------------
   function Get_Clock_Source  (Instance : LPTIM_Instance_Type)
      return LPTIMx_Source_Type
      with Inline;
   --  Get LPTIMx clock source

end LL.RCC.LPTIM;