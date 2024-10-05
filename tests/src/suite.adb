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

with LL.TIM.Test;
with LL.RCC.Test;

package body Suite is

   Result : aliased AUnit.Test_Suites.Test_Suite;
   --  Statically allocated test suite

   ---------------------------------------------------------------------------
   function Suite
      return AUnit.Test_Suites.Access_Test_Suite is
   begin

      Result.Add_Test (LL.TIM.Test.Suite);
      Result.Add_Test (LL.RCC.Test.Suite);

      return Result'Access;

   end Suite;

end Suite;