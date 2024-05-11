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

with CMSIS.Device.GPIO;
   use CMSIS.Device.GPIO;
with CMSIS.Device.GPIO.Instances;
   use CMSIS.Device.GPIO.Instances;

package body LL.GPIO is
   --  General Purpose Input/Output (GPIO) low-layer driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_gpio.h
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_gpio.c

   ---------------------------------------------------------------------------
   procedure Set_Pin_Mode (GPIO : Instance_Type;
                           Pin  : Pin_Type;
                           Mode : Mode_Type) is
   begin

      GPIOx (GPIO).MODER.Arr (Pin_Type'Pos (Pin)) := Mode_Type'Pos (Mode);

   end Set_Pin_Mode;

end LL.GPIO;
