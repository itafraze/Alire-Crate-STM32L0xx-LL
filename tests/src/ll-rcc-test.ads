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

end LL.RCC.Test;
