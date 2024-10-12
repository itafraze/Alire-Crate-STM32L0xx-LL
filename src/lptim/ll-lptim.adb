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

--  with System.BB.Armv6m_Atomic;

with CMSIS.Device;
   use CMSIS.Device;
with CMSIS.Device.LPTIM;
   use CMSIS.Device.LPTIM;
with CMSIS.Device.LPTIM.Instances;
   use CMSIS.Device.LPTIM.Instances;

with LL.BUS;
with LL.RCC.LPTIM;

package body LL.LPTIM is
   --  Low-Power Timer (LPTIM) low-layer driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_lptim.c

   ---------------------------------------------------------------------------
   function Init (Instance : Instance_Type;
                  Init     : Init_Type)
      return Status_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin
      return ERROR when Is_Enabled (Instance);

      LPTIM.CFGR := (@ with delta
         CKSEL => CFGR_CKSEL_Field (
            Clock_Source_Type'Pos (Init.Clock_Source)),
         PRESC => CFGR_PRESC_Field (
            Prescaler_Type'Pos (Init.Prescaler)),
         WAVE => CFGR_WAVE_Field (
            Waveform_Type'Pos (Init.Waveform)),
         WAVPOL => CFGR_WAVPOL_Field (
            Output_Polarity_Type'Pos (Init.Polarity)));

      return SUCCESS;

   end Init;

   ---------------------------------------------------------------------------
   function Deinit (Instance : Instance_Type)
      return Status_Type is
   --
      use all type LL.BUS.APB1_GRP1_Peripheral_Type;
      --
      Select_LPTIM1 : constant LL.BUS.APB1_GRP1_Peripheral_Select_Type := [
         LPTIM1 => True,
         others => False];
   begin
      return ERROR when not Instance'Valid;

      LL.BUS.APB1_GRP1_Force_Reset (Select_LPTIM1);
      LL.BUS.APB1_GRP1_Release_Reset (Select_LPTIM1);

      return SUCCESS;

   end Deinit;

   ---------------------------------------------------------------------------
   procedure Enable (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CR.ENABLE := CR_ENABLE_Field (2#1#);

   end Enable;

   ---------------------------------------------------------------------------
   procedure Disable (Instance : Instance_Type) is
   --  The following sequence is required to solve LPTIM disable HW limitation.
   --  Please check Errata Sheet ES0335 for more details under "MCU may
   --  remain stuck in LPTIM interrupt when entering Stop mode" section.
      use all type LL.RCC.LPTIM.LPTIMx_Source_Type;
      --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
      --  Were_Interrupt_Enabled : constant Boolean := not Interrupt_Disabled;
      --
      LPTIM_Source : LL.RCC.LPTIM.LPTIMx_Source_Type;
      --
      IER : IER_Register;
      --
      CFGR : CFGR_Register;
      --
      CMP : CMP_Register;
      --
      ARR : ARR_Register;
      --
      UNUSED : Status_Type;
      --
   begin

      --  Enter critical section
      --  Disable_Interrupts;

      --  Save LPTIM configuration
      LPTIM_Source := LL.RCC.LPTIM.Get_Clock_Source (Instance);
      IER := LPTIM.IER;
      CFGR := LPTIM.CFGR;
      CMP := LPTIM.CMP;
      ARR := LPTIM.ARR;

      --  Reset LPTIM
      UNUSED := Deinit (Instance);

      if CMP.CMP /= 0
         or else  ARR.ARR /= 0
      then
         --  Restore LPTIM Config
         LL.RCC.LPTIM.Set_Clock_Source (LPTIM1_PCLK1);

         if CMP.CMP /= 0
         then
            Enable (Instance);
            LPTIM.CMP := CMP;
            Clear_Flag_CMPOK (Instance);
         end if;

         if ARR.ARR /= 0
         then
            Enable (Instance);
            LPTIM.ARR := ARR;
            Clear_Flag_ARROK (Instance);
         end if;

         LL.RCC.LPTIM.Set_Clock_Source (LPTIM_Source);
      end if;

      --  Restore configuration registers (LPTIM should be disabled first)
      LPTIM.CR.ENABLE := CR_ENABLE_Field (2#0#);
      LPTIM.IER := IER;
      LPTIM.CFGR := CFGR;

      --  Exit critical section
      --  if Were_Interrupt_Enabled
      --  then
      --     Enable_Interrupts;
      --  end if;

   end Disable;

   ---------------------------------------------------------------------------
   function Is_Enabled (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.CR.ENABLE);

   end Is_Enabled;

   ---------------------------------------------------------------------------
   procedure Start_Counter (Instance       : Instance_Type;
                            Operating_Mode : Operating_Mode_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CR := (@ with delta
         CNTSTRT => CR_CNTSTRT_Field (
            if Operating_Mode = CONTINUOUS then 2#1# else 2#0#),
         SNGSTRT => CR_SNGSTRT_Field (
            if Operating_Mode = ONESHOT then 2#1# else 2#0#));

   end Start_Counter;

   ---------------------------------------------------------------------------
   procedure Set_Update_Mode (Instance    : Instance_Type;
                              Update_Mode : Update_Mode_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.PRELOAD := CFGR_PRELOAD_Field (
         Update_Mode_Type'Pos (Update_Mode));

   end Set_Update_Mode;

   ---------------------------------------------------------------------------
   function Get_Update_Mode (Instance : Instance_Type)
      return Update_Mode_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Update_Mode_Type'Val (LPTIM.CFGR.PRELOAD);

   end Get_Update_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Auto_Reload (Instance          : Instance_Type;
                              Auto_Reload_Value : Auto_Reload_Value_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ARR.ARR := ARR_ARR_Field (Auto_Reload_Value);

   end Set_Auto_Reload;

   ---------------------------------------------------------------------------
   function Get_Auto_Reload (Instance : Instance_Type)
      return Auto_Reload_Value_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Auto_Reload_Value_Type (LPTIM.ARR.ARR);

   end Get_Auto_Reload;

   ---------------------------------------------------------------------------
   procedure Set_Compare (Instance      : Instance_Type;
                          Compare_Value : Compare_Value_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CMP.CMP := CMP_CMP_Field (Compare_Value);

   end Set_Compare;

   ---------------------------------------------------------------------------
   function Get_Compare (Instance : Instance_Type)
      return Compare_Value_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Compare_Value_Type (LPTIM.CMP.CMP);

   end Get_Compare;

   ---------------------------------------------------------------------------
   function Get_Counter (Instance : Instance_Type)
      return Natural is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Natural (LPTIM.CNT.CNT);

   end Get_Counter;

   ---------------------------------------------------------------------------
   procedure Set_Counter_Mode (Instance     : Instance_Type;
                               Counter_Mode : Counter_Mode_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.COUNTMODE := CFGR_COUNTMODE_Field (
         Counter_Mode_Type'Pos (Counter_Mode));

   end Set_Counter_Mode;

   ---------------------------------------------------------------------------
   function Get_Counter_Mode (Instance : Instance_Type)
      return Counter_Mode_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Counter_Mode_Type'Val (LPTIM.CFGR.COUNTMODE);

   end Get_Counter_Mode;

   ---------------------------------------------------------------------------
   procedure Configure_Output (Instance : Instance_Type;
                               Waveform : Waveform_Type;
                               Polarity : Output_Polarity_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR := (@ with delta
         WAVE => CFGR_WAVE_Field (Waveform_Type'Pos (Waveform)),
         WAVPOL => CFGR_WAVPOL_Field (Output_Polarity_Type'Pos (Polarity)));

   end Configure_Output;

   ---------------------------------------------------------------------------
   procedure Set_Waveform (Instance : Instance_Type;
                           Waveform : Waveform_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.WAVE := CFGR_WAVE_Field (Waveform_Type'Pos (Waveform));

   end Set_Waveform;

   ---------------------------------------------------------------------------
   function Get_Waveform (Instance : Instance_Type)
      return Waveform_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Waveform_Type'Val (LPTIM.CFGR.WAVE);

   end Get_Waveform;

   ---------------------------------------------------------------------------
   procedure Set_Polarity (Instance : Instance_Type;
                           Polarity : Output_Polarity_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.WAVPOL := CFGR_WAVPOL_Field (
         Output_Polarity_Type'Pos (Polarity));

   end Set_Polarity;

   ---------------------------------------------------------------------------
   function Get_Polarity (Instance : Instance_Type)
      return Output_Polarity_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Output_Polarity_Type'Val (LPTIM.CFGR.WAVPOL);

   end Get_Polarity;

   ---------------------------------------------------------------------------
   procedure Set_Prescaler (Instance  : Instance_Type;
                            Prescaler : Prescaler_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.PRESC := CFGR_PRESC_Field (Prescaler_Type'Pos (Prescaler));

   end Set_Prescaler;

   ---------------------------------------------------------------------------
   function Get_Prescaler (Instance : Instance_Type)
      return Prescaler_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Prescaler_Type'Val (LPTIM.CFGR.PRESC);

   end Get_Prescaler;

   ---------------------------------------------------------------------------
   procedure Enable_Timeout (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.TIMOUT := CFGR_TIMOUT_Field (2#1#);

   end Enable_Timeout;

   ---------------------------------------------------------------------------
   procedure Disable_Timeout (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.TIMOUT := CFGR_TIMOUT_Field (2#0#);

   end Disable_Timeout;

   ---------------------------------------------------------------------------
   function Is_Enabled_Timeout (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.CFGR.TIMOUT);

   end Is_Enabled_Timeout;

   ---------------------------------------------------------------------------
   procedure Software_Trigger (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.TRIGEN := CFGR_TRIGEN_Field (2#0#);

   end Software_Trigger;

   ---------------------------------------------------------------------------
   procedure Configure_Trigger (Instance : Instance_Type;
                                Source   : Source_Type;
                                Filter   : Filter_Type;
                                Polarity : Trigger_Polarity_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR := (@ with delta
         TRIGSEL => CFGR_TRIGSEL_Field (Source_Type'Pos (Source)),
         TRGFLT => CFGR_TRGFLT_Field (Filter_Type'Pos (Filter)),
         TRIGEN => CFGR_TRIGEN_Field (
            Trigger_Polarity_Type'Pos (Polarity) + 1));

   end Configure_Trigger;

   ---------------------------------------------------------------------------
   function Get_Trigger_Source (Instance : Instance_Type)
      return Source_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Source_Type'Val (LPTIM.CFGR.TRIGSEL);

   end Get_Trigger_Source;

   ---------------------------------------------------------------------------
   function Get_Trigger_Filter (Instance : Instance_Type)
      return Filter_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Filter_Type'Val (LPTIM.CFGR.TRGFLT);

   end Get_Trigger_Filter;

   ---------------------------------------------------------------------------
   function Get_Trigger_Polarity (Instance : Instance_Type)
      return Trigger_Polarity_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Trigger_Polarity_Type'Val (LPTIM.CFGR.TRIGEN);

   end Get_Trigger_Polarity;

   ---------------------------------------------------------------------------
   procedure Set_Clock_Source (Instance     : Instance_Type;
                               Clock_Source : Clock_Source_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.CKSEL := CFGR_CKSEL_Field (
         Clock_Source_Type'Pos (Clock_Source));

   end Set_Clock_Source;

   ---------------------------------------------------------------------------
   function Get_Clock_Source (Instance : Instance_Type)
      return Clock_Source_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Clock_Source_Type'Val (LPTIM.CFGR.CKSEL);

   end Get_Clock_Source;

   ---------------------------------------------------------------------------
   procedure Configure_Clock (Instance : Instance_Type;
                              Filter   : Clock_Filter_Type;
                              Polarity : Clock_Polarity_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR := (@ with delta
         CKFLT => CFGR_CKFLT_Field (Clock_Filter_Type'Pos (Filter)),
         CKPOL => CFGR_CKPOL_Field (Clock_Polarity_Type'Pos (Polarity)));

   end Configure_Clock;

   ---------------------------------------------------------------------------
   function Get_Clock_Polarity (Instance : Instance_Type)
      return Clock_Polarity_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Clock_Polarity_Type'Val (LPTIM.CFGR.CKPOL);

   end Get_Clock_Polarity;

   ---------------------------------------------------------------------------
   function Get_Clock_Filter (Instance : Instance_Type)
      return Clock_Filter_Type is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Clock_Filter_Type'Val (LPTIM.CFGR.CKFLT);

   end Get_Clock_Filter;

   ---------------------------------------------------------------------------
   procedure Set_Encoder_Mode (Instance : Instance_Type;
                               Encoder  : Encoder_Mode) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.CKPOL := CFGR_CKPOL_Field (Encoder_Mode'Pos (Encoder));

   end Set_Encoder_Mode;

   ---------------------------------------------------------------------------
   function Get_Encoder_Mode (Instance : Instance_Type)
      return Encoder_Mode is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Encoder_Mode'Val (LPTIM.CFGR.CKPOL);

   end Get_Encoder_Mode;

   ---------------------------------------------------------------------------
   procedure Enable_Encoder_Mode (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.ENC := CFGR_ENC_Field (2#1#);

   end Enable_Encoder_Mode;

   ---------------------------------------------------------------------------
   procedure Disable_Encoder_Mode (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.CFGR.ENC := CFGR_ENC_Field (2#0#);

   end Disable_Encoder_Mode;

   ---------------------------------------------------------------------------
   function Is_Enabled_Encoder_Mode (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.CFGR.ENC);

   end Is_Enabled_Encoder_Mode;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CMPM (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ICR.CMPMCF := ICR_CMPMCF_Field (2#1#);

   end Clear_Flag_CMPM;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CMPM (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.ISR.CMPM);

   end Is_Active_Flag_CMPM;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ARRM (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ICR.ARRMCF := ICR_ARRMCF_Field (2#1#);

   end Clear_Flag_ARRM;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ARRM (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.ISR.ARRM);

   end Is_Active_Flag_ARRM;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EXTTRIG (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ICR.EXTTRIGCF := ICR_EXTTRIGCF_Field (2#1#);

   end Clear_Flag_EXTTRIG;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EXTTRIG (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.ISR.EXTTRIG);

   end Is_Active_Flag_EXTTRIG;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CMPOK (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ICR.CMPOKCF := ICR_CMPOKCF_Field (2#1#);

   end Clear_Flag_CMPOK;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CMPOK (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.ISR.CMPOK);

   end Is_Active_Flag_CMPOK;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ARROK (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ICR.ARROKCF := ICR_ARROKCF_Field (2#1#);

   end Clear_Flag_ARROK;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ARROK (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.ISR.ARROK);

   end Is_Active_Flag_ARROK;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_UP (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ICR.UPCF := ICR_UPCF_Field (2#1#);

   end Clear_Flag_UP;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_UP (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.ISR.UP);

   end Is_Active_Flag_UP;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_DOWN (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.ICR.DOWNCF := ICR_DOWNCF_Field (2#1#);

   end Clear_Flag_DOWN;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_DOWN (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.ISR.DOWN);

   end Is_Active_Flag_DOWN;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CMPM (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.CMPMIE := IER_CMPMIE_Field (2#1#);

   end Enable_Interrupt_CMPM;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CMPM (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.CMPMIE := IER_CMPMIE_Field (2#0#);

   end Disable_Interrupt_CMPM;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_CMPM (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.IER.CMPMIE);

   end Is_Enabled_Interrupt_CMPM;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_ARRM (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.ARRMIE := IER_ARRMIE_Field (2#1#);

   end Enable_Interrupt_ARRM;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_ARRM (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.ARRMIE := IER_ARRMIE_Field (2#0#);

   end Disable_Interrupt_ARRM;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_ARRM (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.IER.ARRMIE);

   end Is_Enabled_Interrupt_ARRM;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_EXTTRIG (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.EXTTRIGIE := IER_EXTTRIGIE_Field (2#1#);

   end Enable_Interrupt_EXTTRIG;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_EXTTRIG (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.EXTTRIGIE := IER_EXTTRIGIE_Field (2#0#);

   end Disable_Interrupt_EXTTRIG;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_EXTTRIG (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.IER.EXTTRIGIE);

   end Is_Enabled_Interrupt_EXTTRIG;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CMPOK (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.CMPOKIE := IER_CMPOKIE_Field (2#1#);

   end Enable_Interrupt_CMPOK;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CMPOK (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.CMPOKIE := IER_CMPOKIE_Field (2#0#);

   end Disable_Interrupt_CMPOK;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_CMPOK (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.IER.CMPOKIE);

   end Is_Enabled_Interrupt_CMPOK;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_ARROK (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.ARROKIE := IER_ARROKIE_Field (2#1#);

   end Enable_Interrupt_ARROK;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_ARROK (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.ARROKIE := IER_ARROKIE_Field (2#0#);

   end Disable_Interrupt_ARROK;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_ARROK (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.IER.ARROKIE);

   end Is_Enabled_Interrupt_ARROK;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_UP (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.UPIE := IER_UPIE_Field (2#1#);

   end Enable_Interrupt_UP;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_UP (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.UPIE := IER_UPIE_Field (2#0#);

   end Disable_Interrupt_UP;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_UP (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.IER.UPIE);

   end Is_Enabled_Interrupt_UP;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_DOWN (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.DOWNIE := IER_DOWNIE_Field (2#1#);

   end Enable_Interrupt_DOWN;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_DOWN (Instance : Instance_Type) is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      LPTIM.IER.DOWNIE := IER_DOWNIE_Field (2#0#);

   end Disable_Interrupt_DOWN;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_DOWN (Instance : Instance_Type)
      return Boolean is
   --
      LPTIM renames
         LPTIMx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (LPTIM.IER.DOWNIE);

   end Is_Enabled_Interrupt_DOWN;

end LL.LPTIM;
