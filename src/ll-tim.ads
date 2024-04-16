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

with CMSIS.Device.TIM.Instances;
   use all type CMSIS.Device.TIM.Instances.Instance_Type;

package LL.TIM is
   --  Timer (TIM) low-level driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_hal_tim.h

   subtype Instance_Type is
      CMSIS.Device.TIM.Instances.Instance_Type;
   --

   type Counter_Mode_Type is
      (UP, CENTER_DOWN, CENTER_UP, CENTER_UP_DOWN, DOWN)
      with Default_Value => UP;
   --
   --  @enum UP Upcounter
   --  @enum DOWN Downcounter
   --  @enum CENTER_DOWN Counts up and down alternatively. Output compare
   --    interrupt flags of output channels  are set only when the counter is
   --    counting down.
   --  @enum CENTER_UP The counter counts up and down alternatively. Output
   --    compare interrupt flags of output channels  are set only when the
   --    counter is counting up
   --  @enum CENTER_UP_DOWN The counter counts up and down alternatively.
   --    Output compare interrupt flags of output channels  are set only when
   --    the counter is counting up or down.

   type One_Pulse_Mode_Type is
      (REPETITIVE, SINGLE)
      with Default_Value => REPETITIVE;
   --
   --  @enum REPETITIVE Counter is not stopped at update event
   --  @enum SINGLE Counter stops counting at the next update event

   type Update_Source_Type is
      (REGULAR, COUNTER)
      with Default_Value => REGULAR;
   --
   --  @enum REGULAR Counter overflow/underflow, Setting the UG bit or Update
   --    generation through the slave mode controller
   --  @enum COUNTER Only counter overflow/underflow generates a request

   ---------------------------------------------------------------------------
   procedure Enable_Counter (Instance : Instance_Type);
   --  Enable timer counter
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Update_Event (Instance : Instance_Type);
   --  Enable update event generation
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Counter (Instance : Instance_Type);
   --  Disable timer counter
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Update_Event (Instance : Instance_Type);
   --  Disable update event generation
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   function Is_Enabled_Counter (Instance : Instance_Type)
      return Boolean;
   --  Indicates whether the timer counter is enabled
   --
   --  @param Instance ADC peripheral instance
   --  @return Counter enable status

   ---------------------------------------------------------------------------
   function Is_Enabled_Update_Event (Instance : Instance_Type)
      return Boolean;
   --  Indicates whether update event generation is enabled
   --
   --  @param Instance ADC peripheral instance
   --  @return Event enable status

   ---------------------------------------------------------------------------
   procedure Set_Counter_Mode (Instance     : Instance_Type;
                               Counter_Mode : Counter_Mode_Type);
   --  Set the timer counter counting mode
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_COUNTER_MODE_SELECT_INSTANCE
   --
   --  Notes:
   --  - Switching from Center Aligned counter mode to Edge counter mode (or
   --    reverse) requires a timer reset to avoid unexpected direction
   --
   --  @param Instance ADC peripheral instance
   --  @param Counter_Mode Counter mode

   ---------------------------------------------------------------------------
   procedure Set_One_Pulse_Mode (Instance       : Instance_Type;
                                 One_Pulse_Mode : One_Pulse_Mode_Type);
   --  Set one pulse mode
   --
   --  @param Instance ADC peripheral instance
   --  @param Update_Source Update event source

   ---------------------------------------------------------------------------
   procedure Set_Update_Source (Instance      : Instance_Type;
                                Update_Source : Update_Source_Type);
   --  Set update event source
   --
   --  @param Instance ADC peripheral instance
   --  @param Update_Source Update event source

end LL.TIM;