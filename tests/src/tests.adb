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

with Ada.Text_IO;
with AUnit.Reporter.Text;
with AUnit.Run;
with Suite;

procedure Tests
is
   use Ada.Text_IO;
   use AUnit.Reporter.Text;
   use AUnit.Run;

   Reporter : Text_Reporter;
   --

   procedure Runner
      is new Test_Runner (Suite.Suite);
   --

   procedure Os_Abort
      with Import, External_Name => "abort", No_Return;
   --
begin

   New_Line; Put_Line ("STM32L0xx LL library tests start");

   Set_Use_ANSI_Colors (Reporter, True);
   Runner (Reporter);

   New_Line; Put_Line ("STM32L0xx LL library tests completed");
   Os_Abort;

end Tests;
