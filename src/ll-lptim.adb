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

with CMSIS.Device.LPTIM;
   use CMSIS.Device.LPTIM;
with CMSIS.Device.LPTIM.Instances;
   use CMSIS.Device.LPTIM.Instances;

package body LL.LPTIM is
   --  Low-Power Timer (LPTIM) low-layer driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_lptim.c

   ---------------------------------------------------------------------------
   procedure Enable (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CR.ENABLE := 2#1#;

   end Enable;


   ---------------------------------------------------------------------------
   procedure Start_Counter (Instance       : Instance_Type;
                            Operating_Mode : Operating_Mode_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CR := (@ with delta
         CNTSTRT => CR_CNTSTRT_Field (
            if Operating_Mode = CONTINUOUS then 2#1# else 2#0#),
         SNGSTRT => CR_SNGSTRT_Field (
            if Operating_Mode = ONESHOT then 2#1# else 2#0#));

   end Start_Counter;

   ---------------------------------------------------------------------------
   procedure Set_Update_Mode (Instance    : Instance_Type;
                              Update_Mode : Update_Mode_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.PRELOAD :=
         CFGR_PRELOAD_Field (Update_Mode_Type'Pos (Update_Mode));

   end Set_Update_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Auto_Reload (Instance          : Instance_Type;
                              Auto_Reload_Value : Auto_Reload_Value_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ARR.ARR :=
         ARR_ARR_Field (Auto_Reload_Value);

   end Set_Auto_Reload;

   ---------------------------------------------------------------------------
   procedure Set_Compare (Instance      : Instance_Type;
                          Compare_Value : Compare_Value_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CMP.CMP :=
         CMP_CMP_Field (Compare_Value);

   end Set_Compare;

   ---------------------------------------------------------------------------
   procedure Set_Counter_Mode (Instance     : Instance_Type;
                               Counter_Mode : Counter_Mode_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.COUNTMODE :=
         CFGR_COUNTMODE_Field (Counter_Mode_Type'Pos (Counter_Mode));

   end Set_Counter_Mode;

   ---------------------------------------------------------------------------
   procedure Configure_Output (Instance : Instance_Type;
                               Waveform : Waveform_Type;
                               Polarity : Output_Polarity_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR := (@ with delta
         WAVE => CFGR_WAVE_Field (Waveform_Type'Pos (Waveform)),
         WAVPOL => CFGR_WAVPOL_Field (Output_Polarity_Type'Pos (Polarity)));

   end Configure_Output;

   ---------------------------------------------------------------------------
   procedure Set_Waveform (Instance : Instance_Type;
                           Waveform : Waveform_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.WAVE :=
         CFGR_WAVE_Field (Waveform_Type'Pos (Waveform));

   end Set_Waveform;

   ---------------------------------------------------------------------------
   procedure Set_Polarity (Instance : Instance_Type;
                           Polarity : Output_Polarity_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.WAVPOL :=
         CFGR_WAVPOL_Field (Output_Polarity_Type'Pos (Polarity));

   end Set_Polarity;

   ---------------------------------------------------------------------------
   procedure Set_Prescaler (Instance  : Instance_Type;
                            Prescaler : Prescaler_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.PRESC :=
         CFGR_PRESC_Field (Prescaler_Type'Pos (Prescaler));

   end Set_Prescaler;

   ---------------------------------------------------------------------------
   procedure Enable_Timeout (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.TIMOUT :=
         CFGR_TIMOUT_Field (2#1#);

   end Enable_Timeout;

   ---------------------------------------------------------------------------
   procedure Disable_Timeout (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.TIMOUT :=
         CFGR_TIMOUT_Field (2#0#);

   end Disable_Timeout;

   ---------------------------------------------------------------------------
   procedure Software_Trigger (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.TRIGEN :=
         CFGR_TRIGEN_Field (2#0#);

   end Software_Trigger;


   ---------------------------------------------------------------------------
   procedure Configure_Trigger (Instance : Instance_Type;
                                Source   : Source_Type;
                                Filter   : Filter_Type;
                                Polarity : Trigger_Polarity_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR := (@ with delta
         TRIGSEL => CFGR_TRIGSEL_Field (Source_Type'Pos (Source)),
         TRGFLT => CFGR_TRGFLT_Field (Filter_Type'Pos (Filter)),
         TRIGEN => CFGR_TRIGEN_Field (
            Trigger_Polarity_Type'Pos (Polarity) + 1));

   end Configure_Trigger;

   ---------------------------------------------------------------------------
   procedure Set_Clock_Source (Instance     : Instance_Type;
                               Clock_Source : Clock_Source_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR.CKSEL :=
         CFGR_CKSEL_Field (Clock_Source_Type'Pos (Clock_Source));

   end Set_Clock_Source;

   ---------------------------------------------------------------------------
   procedure Configure_Clock (Instance : Instance_Type;
                              Filter   : Clock_Filter_Type;
                              Polarity : Clock_Polarity_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).CFGR := (@ with delta
         CKFLT => CFGR_CKFLT_Field (Clock_Filter_Type'Pos (Filter)),
         CKPOL => CFGR_CKPOL_Field (Clock_Polarity_Type'Pos (Polarity)));

   end Configure_Clock;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CMPM (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ICR.CMPMCF :=
         ICR_CMPMCF_Field (2#1#);

   end Clear_Flag_CMPM;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CMPM (Instance : Instance_Type)
      return Boolean is
      --
   begin

      return Boolean'Enum_Val (
         LPTIMx (All_Instance_Type (Instance)).ISR.CMPM);

   end Is_Active_Flag_CMPM;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ARRM (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ICR.ARRMCF :=
         ICR_ARRMCF_Field (2#1#);

   end Clear_Flag_ARRM;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ARRM (Instance : Instance_Type)
      return Boolean is
      --
   begin

      return Boolean'Enum_Val (
         LPTIMx (All_Instance_Type (Instance)).ISR.ARRM);

   end Is_Active_Flag_ARRM;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EXTTRIG (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ICR.EXTTRIGCF :=
         ICR_EXTTRIGCF_Field (2#1#);

   end Clear_Flag_EXTTRIG;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EXTTRIG (Instance : Instance_Type)
      return Boolean is
      --
   begin

      return Boolean'Enum_Val (
         LPTIMx (All_Instance_Type (Instance)).ISR.EXTTRIG);

   end Is_Active_Flag_EXTTRIG;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CMPOK (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ICR.CMPOKCF :=
         ICR_CMPOKCF_Field (2#1#);

   end Clear_Flag_CMPOK;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CMPOK (Instance : Instance_Type)
      return Boolean is
      --
   begin

      return Boolean'Enum_Val (
         LPTIMx (All_Instance_Type (Instance)).ISR.CMPOK);

   end Is_Active_Flag_CMPOK;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ARROK (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ICR.ARROKCF :=
         ICR_ARROKCF_Field (2#1#);

   end Clear_Flag_ARROK;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ARROK (Instance : Instance_Type)
      return Boolean is
      --
   begin

      return Boolean'Enum_Val (
         LPTIMx (All_Instance_Type (Instance)).ISR.ARROK);

   end Is_Active_Flag_ARROK;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_UP (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ICR.UPCF :=
         ICR_UPCF_Field (2#1#);

   end Clear_Flag_UP;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_UP (Instance : Instance_Type)
      return Boolean is
      --
   begin

      return Boolean'Enum_Val (
         LPTIMx (All_Instance_Type (Instance)).ISR.UP);

   end Is_Active_Flag_UP;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_DOWN (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).ICR.DOWNCF :=
         ICR_DOWNCF_Field (2#1#);

   end Clear_Flag_DOWN;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_DOWN (Instance : Instance_Type)
      return Boolean is
      --
   begin

      return Boolean'Enum_Val (
         LPTIMx (All_Instance_Type (Instance)).ISR.DOWN);

   end Is_Active_Flag_DOWN;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CMPM (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.CMPMIE :=
         IER_CMPMIE_Field (2#1#);

   end Enable_Interrupt_CMPM;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CMPM (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.CMPMIE :=
         IER_CMPMIE_Field (2#0#);

   end Disable_Interrupt_CMPM;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_ARRM (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.ARRMIE :=
         IER_ARRMIE_Field (2#1#);

   end Enable_Interrupt_ARRM;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_ARRM (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.ARRMIE :=
         IER_ARRMIE_Field (2#0#);

   end Disable_Interrupt_ARRM;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_EXTTRIG (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.EXTTRIGIE :=
         IER_EXTTRIGIE_Field (2#1#);

   end Enable_Interrupt_EXTTRIG;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_EXTTRIG (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.EXTTRIGIE :=
         IER_EXTTRIGIE_Field (2#0#);

   end Disable_Interrupt_EXTTRIG;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CMPOK (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.EXTTRIGIE :=
         IER_CMPOKIE_Field (2#1#);

   end Enable_Interrupt_CMPOK;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CMPOK (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.EXTTRIGIE :=
         IER_CMPOKIE_Field (2#0#);

   end Disable_Interrupt_CMPOK;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_ARROK (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.ARROKIE :=
         IER_ARROKIE_Field (2#1#);

   end Enable_Interrupt_ARROK;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_ARROK (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.ARROKIE :=
         IER_ARROKIE_Field (2#0#);

   end Disable_Interrupt_ARROK;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_UP (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.UPIE :=
         IER_UPIE_Field (2#1#);

   end Enable_Interrupt_UP;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_UP (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.UPIE :=
         IER_UPIE_Field (2#0#);

   end Disable_Interrupt_UP;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_DOWN (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.DOWNIE :=
         IER_DOWNIE_Field (2#1#);

   end Enable_Interrupt_DOWN;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_DOWN (Instance : Instance_Type) is
      --
   begin

      LPTIMx (All_Instance_Type (Instance)).IER.DOWNIE :=
         IER_DOWNIE_Field (2#0#);

   end Disable_Interrupt_DOWN;

end LL.LPTIM;
