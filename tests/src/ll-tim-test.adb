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
--    2024.04 E. Zarfati
--       - First version
--
------------------------------------------------------------------------------

with AUnit.Assertions;
   use AUnit.Assertions;
with AUnit.Test_Caller;

with CMSIS.Device;
   use CMSIS.Device;
with CMSIS.Device.TIM;
   use CMSIS.Device.TIM;
with CMSIS.Device.TIM.Instances;
   use CMSIS.Device.TIM.Instances;

package body LL.TIM.Test is

   package Caller_Zero
      is new AUnit.Test_Caller (Zero_Fixture);
   --

   Result : aliased AUnit.Test_Suites.Test_Suite;
   --  Statically allocated test suite

   ---------------------------------------------------------------------------
   procedure Enable_Counter_Sets_CEN (UNUSED : in out Zero_Fixture);

   ---------------------------------------------------------------------------
   overriding procedure Set_Up (T : in out Zero_Fixture) is
      --
      TIM2_Periph_Array : array (1 .. (TIM2_Periph'Size / 8 / 4)) of UInt32
         with Address => TIM2_Periph'Address;
      TIM3_Periph_Array : array (1 .. (TIM3_Periph'Size / 8 / 4)) of UInt32
         with Address => TIM3_Periph'Address;
      TIM21_Periph_Array : array (1 .. (TIM21_Periph'Size / 8 / 4)) of UInt32
         with Address => TIM21_Periph'Address;
      TIM22_Periph_Array : array (1 .. (TIM22_Periph'Size / 8 / 4)) of UInt32
         with Address => TIM22_Periph'Address;
      TIM6_Periph_Array : array (1 .. (TIM6_Periph'Size / 8 / 4)) of UInt32
         with Address => TIM6_Periph'Address;
      TIM7_Periph_Array : array (1 .. (TIM7_Periph'Size / 8 / 4)) of UInt32
         with Address => TIM7_Periph'Address;
   begin

      TIM2_Periph_Array := [others => 0];
      TIM3_Periph_Array := [others => 0];
      TIM21_Periph_Array := [others => 0];
      TIM22_Periph_Array := [others => 0];
      TIM6_Periph_Array := [others => 0];
      TIM7_Periph_Array := [others => 0];

   end Set_Up;

   ---------------------------------------------------------------------------
   function Suite
      return AUnit.Test_Suites.Access_Test_Suite is
      --
      Suite_Prefix_Zero : constant String := "LL.TIM::Zero_Fixture::";
   begin

      Result.Add_Test (
        Caller_Zero.Create (
            Suite_Prefix_Zero
               & "Init_Success_With_Defaults",
            Enable_Counter_Sets_CEN'Access));

      return Result'Access;

   end Suite;

   ---------------------------------------------------------------------------
   procedure Enable_Counter_Sets_CEN (UNUSED : in out Zero_Fixture) is
      --  LL.TIM.Enable_Counter sets TIM_CR1_CEN to 1
   begin

      Enable_Counter (TIM2);
      Assert (
         TIM2_Periph.CR1.CEN = 1,
         "LL.TIM.Enable_Counter did not set TIM2's CR1.CEN");

      Enable_Counter (TIM21);
      Assert (
         TIM21_Periph.CR1.CEN = 1,
         "LL.TIM.Enable_Counter did not set TIM21's CR1.CEN");

   end Enable_Counter_Sets_CEN;

end LL.TIM.Test;
