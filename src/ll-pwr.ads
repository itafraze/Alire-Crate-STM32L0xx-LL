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

package LL.PWR is
   --  Power (PWR) low-layer driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_pwr.h

   type Voltage_Scaling_Type is
      (SCALE1, SCALE2, SCALE3)
      with Default_Value => SCALE1;
   --

   ---------------------------------------------------------------------------
   procedure Set_Regulator_Voltage_Scaling (
      Voltage_Scaling : Voltage_Scaling_Type);
   --  Set the main internal regulator output voltage
   --
   --  @param Voltage_Scaling

end LL.PWR;
