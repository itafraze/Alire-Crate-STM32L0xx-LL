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
with CMSIS.Device.RCC.Instances;
   use CMSIS.Device.RCC.Instances;

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

      return Result'Access;

   end Suite;

end LL.RCC.Test;
