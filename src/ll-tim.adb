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

with CMSIS.Device.TIM;
   use CMSIS.Device.TIM;
with CMSIS.Device.TIM.Instances;
   use CMSIS.Device.TIM.Instances;

package body LL.TIM is
   --  Timer (TIM) low-level driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_tim.c

   ---------------------------------------------------------------------------
   procedure Enable_Counter (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      TIM_Instance.CR1.CEN := CR1_CEN_Field (2#1#);
   end Enable_Counter;

   ---------------------------------------------------------------------------
   procedure Enable_Update_Event (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      TIM_Instance.CR1.UDIS := CR1_UDIS_Field (2#0#);
   end Enable_Update_Event;

   ---------------------------------------------------------------------------
   procedure Disable_Counter (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      TIM_Instance.CR1.CEN := CR1_CEN_Field (2#0#);
   end Disable_Counter;

   ---------------------------------------------------------------------------
   procedure Disable_Update_Event (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      TIM_Instance.CR1.UDIS := CR1_UDIS_Field (2#1#);
   end Disable_Update_Event;

   ---------------------------------------------------------------------------
   function Is_Enabled_Counter (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      return Boolean'Enum_Val (TIM_Instance.CR1.CEN);
   end Is_Enabled_Counter;

   ---------------------------------------------------------------------------
   function Is_Enabled_Update_Event (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      return not (Boolean'Enum_Val (TIM_Instance.CR1.UDIS));
   end Is_Enabled_Update_Event;

   ---------------------------------------------------------------------------
   procedure Set_Counter_Mode (Instance     : Instance_Type;
                               Counter_Mode : Counter_Mode_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      TIM_Instance.CR1 := (@ with delta
         DIR => CR1_DIR_Field (case Counter_Mode is
            when DOWN   => 2#1#,
            when others => 2#0#),
         CMS => CR1_CMS_Field (case Counter_Mode is
            when UP | DOWN => 2#0#,
            when others    => Counter_Mode_Type'Pos (Counter_Mode)));
   end Set_Counter_Mode;

   ---------------------------------------------------------------------------
   procedure Set_One_Pulse_Mode (Instance       : Instance_Type;
                                 One_Pulse_Mode : One_Pulse_Mode_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      TIM_Instance.CR1.OPM := One_Pulse_Mode_Type'Pos (One_Pulse_Mode);
   end Set_One_Pulse_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Update_Source (Instance      : Instance_Type;
                                Update_Source : Update_Source_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin
      TIM_Instance.CR1.URS := Update_Source_Type'Pos (Update_Source);
   end Set_Update_Source;

end LL.TIM;