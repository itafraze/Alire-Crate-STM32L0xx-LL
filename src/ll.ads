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

package LL is
   --  Low-Level (LL) driver
   --
   --  The low-layer (LL) drivers are designed to offer a fast light-weight
   --  expert-oriented layer which is closer to the hardware than the HAL

   type Status_Type is
      (SUCCESS, ERROR)
      with Default_Value => SUCCESS;
   --  Type of LL Status

end LL;
