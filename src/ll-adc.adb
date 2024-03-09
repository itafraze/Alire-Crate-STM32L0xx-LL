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

with CMSIS.Device;
   use CMSIS.Device;
with CMSIS.Device.ADC.Instances;
   use CMSIS.Device.ADC.Instances;
with CMSIS.Device.ADC;
   use CMSIS.Device.ADC;

package body LL.ADC is
   --  Analog-to-Digital Converter (ADC) low-level driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_adc.c

   ---------------------------------------------------------------------------
   function REG_Init (Instance : Instance_Type;
                      Init     : REG_Init_Type)
      return Status_Type is
   begin

      return ERROR when Is_Enabled (Instance);

      ADCx (All_Instance_Type (Instance)).CFGR1 := (@ with delta
         EXTSEL => 2#0#,
         EXTEN => 2#0#,
         DISCEN => 2#0#,
         CONT => 2#0#,
         DMAEN => 2#0#,
         DMACFG => 2#0#,
         OVRMOD => 2#0#,
         EXTEN => (case Init.Trigger_Source is
            when SOFTWARE => 2#0#,
            when others => 2#1#),
         EXTSEL => (case Init.Trigger_Source is
            when EXT_TIM21_CH2 => 16#1#,
            when EXT_TIM2_TRGO => 16#2#,
            when EXT_TIM2_CH4 => 16#3#,
            when EXT_TIM22_TRGO | EXT_TIM21_TRGO => 16#4#,
            when EXT_TIM2_CH3 => 16#5#,
            when EXT_TIM3_TRGO => 16#6#,
            when EXT_EXTI_LINE11 => 16#7#,
            when others => 16#0#),
         DISCEN => REG_Sequencer_Discontinuous_Mode_Type'Pos (
            Init.Sequencer_Discontinuous),
         CONT => REG_Continuous_Mode_Type'Pos (Init.Continuous_Mode),
         DMAEN => (case Init.DMA_Transfer is
            when NONE => 2#0#,
            when others => 2#1#),
         DMACFG => (case Init.DMA_Transfer is
            when UNLIMIT => 2#1#,
            when others => 2#0#),
         OVRMOD => REG_Overrun_Behaviour_Type'Pos (Init.Overrun));

      return SUCCESS;

   end REG_Init;

   ---------------------------------------------------------------------------
   procedure Set_Common_Clock (Instance     : Instance_Type;
                               Common_Clock : Common_Clock_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CCR.PRESC :=
         Common_Clock_Type'Pos (Common_Clock);

   end Set_Common_Clock;

   ---------------------------------------------------------------------------
   procedure Set_Common_Frequency_Mode (
      Instance              : Instance_Type;
      Common_Frequency_Mode : Common_Frequency_Mode_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CCR.LFMEN :=
         Common_Frequency_Mode_Type'Pos (Common_Frequency_Mode);

   end Set_Common_Frequency_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Common_Path_Internal_Channel (
      Instance      : Instance_Type;
      Path_Internal : Common_Path_Internal_Select_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CCR := (@ with delta
         VREFEN => Boolean'Pos (Path_Internal (VREFINT)),
         TSEN => Boolean'Pos (Path_Internal (TEMPSENSOR)),
         VLCDEN => Boolean'Pos (Path_Internal (VLCD)));

   end Set_Common_Path_Internal_Channel;

   ---------------------------------------------------------------------------
   procedure Set_Clock (Instance     : Instance_Type;
                        Clock_Source : Clock_Source_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR2.CKMODE :=
         Clock_Source_Type'Pos (Clock_Source);

   end Set_Clock;

   ---------------------------------------------------------------------------
   procedure Set_Calibration_Factor (Instance           : Instance_Type;
                                     Calibration_Factor : Natural) is
   begin

      ADCx (All_Instance_Type (Instance)).CALFACT.CALFACT :=
         CALFACT_CALFACT_Field (Calibration_Factor);

   end Set_Calibration_Factor;

   ---------------------------------------------------------------------------
   procedure Set_Resolution (Instance   : Instance_Type;
                             Resolution : Resolution_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1.RES :=
         Resolution_Type'Pos (Resolution);

   end Set_Resolution;

   ---------------------------------------------------------------------------
   procedure Set_Data_Alignment (Instance       : Instance_Type;
                                 Data_Alignment : Data_Alignment_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1.ALIGN :=
         Data_Alignment_Type'Pos (Data_Alignment);

   end Set_Data_Alignment;

   ---------------------------------------------------------------------------
   procedure Set_Low_Power_Mode (Instance       : Instance_Type;
                                 Low_Power_Mode : Low_Power_Mode_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1 := (@ with delta
         AUTOFF => (case Low_Power_Mode is
            when AUTOPOWEROFF | AUTOWAIT_AUTOPOWEROFF => 2#1#,
            when others => 2#0#),
         AUTDLY => (case Low_Power_Mode is
            when AUTOWAIT | AUTOWAIT_AUTOPOWEROFF => 2#1#,
            when others => 2#0#));

   end Set_Low_Power_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Sampling_Time_Common_Channels (
      Instance      : Instance_Type;
      Sampling_Time : Sampling_Time_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).SMPR.SMPR :=
         Sampling_Time_Type'Pos (Sampling_Time);

   end Set_Sampling_Time_Common_Channels;

   ---------------------------------------------------------------------------
   procedure REG_Set_Trigger_Source (
      Instance       : Instance_Type;
      Trigger_Source : REG_Trigger_Source_Type) is
   begin
      ADCx (All_Instance_Type (Instance)).CFGR1 := (@ with delta
         EXTEN => (case Trigger_Source is
            when SOFTWARE => 2#0#,
            when others => 2#1#),
         EXTSEL => (case Trigger_Source is
            when EXT_TIM21_CH2 => 16#1#,
            when EXT_TIM2_TRGO => 16#2#,
            when EXT_TIM2_CH4 => 16#3#,
            when EXT_TIM22_TRGO | EXT_TIM21_TRGO => 16#4#,
            when EXT_TIM2_CH3 => 16#5#,
            when EXT_TIM3_TRGO => 16#6#,
            when EXT_EXTI_LINE11 => 16#7#,
            when others => 16#0#));

   end REG_Set_Trigger_Source;

   ---------------------------------------------------------------------------
   procedure REG_Set_Trigger_Edge (Instance     : Instance_Type;
                                   Trigger_Edge : REG_Trigger_Edge_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1.EXTEN :=
         REG_Trigger_Edge_Type'Pos (Trigger_Edge) + 1;

   end REG_Set_Trigger_Edge;

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Scan_Direction (
      Instance       : Instance_Type;
      Scan_Direction : REG_Sequencer_Scan_Direction_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1.SCANDIR :=
         REG_Sequencer_Scan_Direction_Type'Pos (Scan_Direction);

   end REG_Set_Sequencer_Scan_Direction;

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Discontinuous_Mode (
      Instance                : Instance_Type;
      Sequencer_Discontinuous : REG_Sequencer_Discontinuous_Mode_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1.DISCEN :=
         REG_Sequencer_Discontinuous_Mode_Type'Pos (Sequencer_Discontinuous);

   end REG_Set_Sequencer_Discontinuous_Mode;

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Channels (Instance : Instance_Type;
                                         Channels : Channel_Select_Type) is
   begin

      for Ch in Channel_Select_Type'Range
      loop
         ADCx (All_Instance_Type (Instance)).CHSELR.CHSEL.Arr (
            Channel_Type'Pos (Ch)) := Boolean'Pos (Channels (Ch));
      end loop;

   end REG_Set_Sequencer_Channels;

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Channels_Add (
      Instance : Instance_Type;
      Channels : Channel_Select_Type) is
   begin

      for Ch in Channel_Select_Type'Range
      loop
         if Channels (Ch) = True
         then
            ADCx (All_Instance_Type (Instance)).CHSELR.CHSEL.Arr (
               Channel_Type'Pos (Ch)) := 2#1#;
         end if;
      end loop;

   end REG_Set_Sequencer_Channels_Add;

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Channels_Remove (
      Instance : Instance_Type;
      Channels : Channel_Select_Type) is
   begin

      for Ch in Channel_Select_Type'Range
      loop
         if Channels (Ch) = False
         then
            ADCx (All_Instance_Type (Instance)).CHSELR.CHSEL.Arr (
               Channel_Type'Pos (Ch)) := 2#0#;
         end if;
      end loop;

   end REG_Set_Sequencer_Channels_Remove;

   ---------------------------------------------------------------------------
   procedure REG_Set_Continuous_Mode (
      Instance   : Instance_Type;
      Continuous : REG_Continuous_Mode_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1 := (@ with delta
         CONT => REG_Continuous_Mode_Type'Pos (Continuous));

   end REG_Set_Continuous_Mode;

   ---------------------------------------------------------------------------
   procedure REG_Set_DMA_Transfer (Instance     : Instance_Type;
                                   DMA_Transfer : REG_DMA_Transfer_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1 := (@ with delta
         DMAEN => (case DMA_Transfer is
            when NONE => 2#0#,
            when others => 2#1#),
         DMACFG => (case DMA_Transfer is
            when UNLIMIT => 2#1#,
            when others => 2#0#));

   end REG_Set_DMA_Transfer;

   ---------------------------------------------------------------------------
   procedure REG_Set_Overrun (Instance : Instance_Type;
                              Overrun  : REG_Overrun_Behaviour_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1.OVRMOD :=
         REG_Overrun_Behaviour_Type'Pos (Overrun);

   end REG_Set_Overrun;

   ---------------------------------------------------------------------------
   procedure Set_Analog_Watchdog_Monitored_Channels (
      Instance : Instance_Type;
      Group    : Analog_Watchdog_Monitored_Channels_Type;
      Channel  : Channel_Type := Channel_Type'First) is
   --  Implementation notes:
   --  - From the datasheet: The channel selected by the AWDCH[4:0] bits must
   --    be also set into the CHSELR register. The implementation of
   --    LL_ADC_SetAnalogWDMonitChannels does not do it however
   begin

      ADCx (All_Instance_Type (Instance)).CFGR1 := (@ with delta
         AWDCH => (case Group is
            when SINGLE_CHANNEL => Channel_Type'Pos (Channel),
            when others => 2#0#),
         AWDSGL => (case Group is
            when SINGLE_CHANNEL => 2#1#,
            when others => 2#0#),
         AWDEN => (case Group is
            when DISABLE => 2#0#,
            when others => 2#1#));

   end Set_Analog_Watchdog_Monitored_Channels;

   ---------------------------------------------------------------------------
   procedure Config_Analog_Watchdog_Thresholds (
      Instance       : Instance_Type;
      High_Threshold : Natural;
      Low_Threshold  : Natural) is
   begin

      ADCx (All_Instance_Type (Instance)).TR.HT :=
         TR_HT_Field (High_Threshold);
      ADCx (All_Instance_Type (Instance)).TR.LT :=
         TR_LT_Field (Low_Threshold);

   end Config_Analog_Watchdog_Thresholds;

   ---------------------------------------------------------------------------
   procedure Set_Analog_Watchdog_Thresholds (
      Instance  : Instance_Type;
      Threshold : Analog_Watchdog_Threshold_Type;
      Value     : Natural) is
   begin
      case Threshold is
         when HIGH =>
            ADCx (All_Instance_Type (Instance)).TR.HT := TR_HT_Field (Value);
         when LOW =>
            ADCx (All_Instance_Type (Instance)).TR.LT := TR_LT_Field (Value);
      end case;
   end Set_Analog_Watchdog_Thresholds;

   ---------------------------------------------------------------------------
   procedure Set_Oversampling_Scope (
      Instance : Instance_Type;
      Scope    : Oversampling_Scope_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR2.OVSE :=
         CFGR2_OVSE_Field (Oversampling_Scope_Type'Pos (Scope));

   end Set_Oversampling_Scope;

   ---------------------------------------------------------------------------
   procedure Set_Oversampling_Discontinuous (
      Instance : Instance_Type;
      Mode     : Oversampling_Discontinuous_Mode_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR2.TOVS :=
         CFGR2_TOVS_Field (Oversampling_Discontinuous_Mode_Type'Pos (Mode));

   end Set_Oversampling_Discontinuous;

   ---------------------------------------------------------------------------
   procedure Config_Oversampling_Ratio_Shift (
      Instance : Instance_Type;
      Ratio    : Oversampling_Ratio_Type;
      Shift    : Oversampling_Shift_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CFGR2.OVSS :=
         CFGR2_OVSS_Field (Oversampling_Ratio_Type'Pos (Ratio));
      ADCx (All_Instance_Type (Instance)).CFGR2.OVSR :=
         CFGR2_OVSR_Field (Oversampling_Shift_Type'Pos (Shift));

   end Config_Oversampling_Ratio_Shift;

   ---------------------------------------------------------------------------
   procedure Enable_Internal_Regulator (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CR := (@ with delta
         ADVREGEN => 2#1#,
         ADCAL => 2#0#,
         ADSTP => 2#0#,
         ADSTART => 2#0#,
         ADDIS => 2#0#,
         ADEN => 2#0#);

   end Enable_Internal_Regulator;

   ---------------------------------------------------------------------------
   procedure Disable_Internal_Regulator (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CR := (@ with delta
         ADVREGEN => 2#0#,
         ADCAL => 2#0#,
         ADSTP => 2#0#,
         ADSTART => 2#0#,
         ADDIS => 2#0#,
         ADEN => 2#0#);

   end Disable_Internal_Regulator;

   ---------------------------------------------------------------------------
   procedure Enable (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CR := (@ with delta
         ADEN => 2#1#,
         ADCAL => 2#0#,
         ADSTP => 2#0#,
         ADSTART => 2#0#,
         ADDIS => 2#0#,
         ADEN => 2#0#);

   end Enable;

   ---------------------------------------------------------------------------
   procedure Disable (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CR := (@ with delta
         ADDIS => 2#1#,
         ADCAL => 2#0#,
         ADSTP => 2#0#,
         ADSTART => 2#0#,
         ADDIS => 2#0#,
         ADEN => 2#0#);

   end Disable;

   ---------------------------------------------------------------------------
   function Is_Enabled (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).CR.ADEN /= 2#0#);

   ---------------------------------------------------------------------------
   procedure Start_Calibration (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CR := (@ with delta
         ADCAL => 2#1#,
         ADCAL => 2#0#,
         ADSTP => 2#0#,
         ADSTART => 2#0#,
         ADDIS => 2#0#,
         ADEN => 2#0#);

   end Start_Calibration;

   ---------------------------------------------------------------------------
   procedure REG_Start_Conversion (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CR := (@ with delta
         ADSTART => 2#1#,
         ADCAL => 2#0#,
         ADSTP => 2#0#,
         ADSTART => 2#0#,
         ADDIS => 2#0#,
         ADEN => 2#0#);

   end REG_Start_Conversion;

   ---------------------------------------------------------------------------
   procedure REG_Stop_Conversion (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).CR := (@ with delta
         ADSTP => 2#1#,
         ADCAL => 2#0#,
         ADSTP => 2#0#,
         ADSTART => 2#0#,
         ADDIS => 2#0#,
         ADEN => 2#0#);

   end REG_Stop_Conversion;

   ---------------------------------------------------------------------------
   function REG_Read_Conversion_Data_32 (Instance : Instance_Type)
      return CMSIS.Device.UInt32 is
      (CMSIS.Device.UInt32 (ADCx (All_Instance_Type (Instance)).DR.DATA));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ADRDY (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).ISR.ADRDY /= 2#0#);

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOC (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).ISR.EOC /= 2#0#);

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOS (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).ISR.EOS /= 2#0#);

   ---------------------------------------------------------------------------
   function Is_Active_Flag_OVR (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).ISR.OVR /= 2#0#);

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOSMP (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).ISR.EOSMP /= 2#0#);

   ---------------------------------------------------------------------------
   function Is_Active_Flag_AWD1 (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).ISR.AWD /= 2#0#);

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOCAL (Instance : Instance_Type)
      return Boolean is
      (ADCx (All_Instance_Type (Instance)).ISR.EOCAL /= 2#0#);

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ADRDY (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).ISR.ADRDY := 2#1#;

   end Clear_Flag_ADRDY;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOC (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).ISR.EOC := 2#1#;

   end Clear_Flag_EOC;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOS (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).ISR.EOS := 2#1#;

   end Clear_Flag_EOS;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_OVR (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).ISR.OVR := 2#1#;

   end Clear_Flag_OVR;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOSMP (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).ISR.EOSMP := 2#1#;

   end Clear_Flag_EOSMP;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_AWD1 (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).ISR.AWD := 2#1#;

   end Clear_Flag_AWD1;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOCAL (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).ISR.EOCAL := 2#1#;

   end Clear_Flag_EOCAL;

   ---------------------------------------------------------------------------
   procedure Enable_IT_ADRDY (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.ADRDYIE := 2#1#;

   end Enable_IT_ADRDY;

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOC (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOCIE := 2#1#;

   end Enable_IT_EOC;

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOS (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOSIE := 2#1#;

   end Enable_IT_EOS;

   ---------------------------------------------------------------------------
   procedure Enable_IT_OVR (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.OVRIE := 2#1#;

   end Enable_IT_OVR;

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOSMP (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOSMPIE := 2#1#;

   end Enable_IT_EOSMP;

   ---------------------------------------------------------------------------
   procedure Enable_IT_AWD1 (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.AWDIE := 2#1#;

   end Enable_IT_AWD1;

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOCAL (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOCALIE := 2#1#;

   end Enable_IT_EOCAL;

   ---------------------------------------------------------------------------
   procedure Disable_IT_ADRDY (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.ADRDYIE := 2#0#;

   end Disable_IT_ADRDY;

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOC (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOCIE := 2#0#;

   end Disable_IT_EOC;

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOS (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOSIE := 2#0#;

   end Disable_IT_EOS;

   ---------------------------------------------------------------------------
   procedure Disable_IT_OVR (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.OVRIE := 2#0#;

   end Disable_IT_OVR;

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOSMP (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOSMPIE := 2#0#;

   end Disable_IT_EOSMP;

   ---------------------------------------------------------------------------
   procedure Disable_IT_AWD1 (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.AWDIE := 2#0#;

   end Disable_IT_AWD1;

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOCAL (Instance : Instance_Type) is
   begin

      ADCx (All_Instance_Type (Instance)).IER.EOCALIE := 2#0#;

   end Disable_IT_EOCAL;

end LL.ADC;
