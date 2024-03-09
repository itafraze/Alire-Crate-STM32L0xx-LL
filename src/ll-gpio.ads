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

with CMSIS.Device.GPIO.Instances;
   use all type CMSIS.Device.GPIO.Instances.Instance_Type;

package LL.GPIO is
   --  General Purpose Input/Output (GPIO) low-level driver
   --
   --  Analog-to-Digital Converter (ADC) peripheral initialization functions
   --  and APIs
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_gpio.h

   subtype Instance_Type is
      CMSIS.Device.GPIO.Instances.Instance_Type;
   --

   subtype Pin_Type is
      CMSIS.Device.GPIO.Instances.Pin_Type;
   --

   type Mode_Type is
      (INPUT, OUTPUT, ALTERNATE, ANALOG)
      with Default_Value => ANALOG;
   --

   ---------------------------------------------------------------------------
   procedure Set_Pin_Mode (GPIO : Instance_Type;
                           Pin  : Pin_Type;
                           Mode : Mode_Type);
   --  Configure gpio mode for a dedicated pin on dedicated port
   --
   --  @param GPIO GPIO Port
   --  @param Pin Dedicated port's pin
   --  @param Mode

end LL.GPIO;
