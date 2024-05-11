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

with CMSIS.Device;
   use CMSIS.Device;
with CMSIS.Device.TIM;
   use CMSIS.Device.TIM;
with CMSIS.Device.TIM.Instances;
   use CMSIS.Device.TIM.Instances;

package body LL.TIM is
   --  Timer (TIM) low-layer driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_tim.h
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_tim.c

   ---------------------------------------------------------------------------
   procedure Clear_Flag_UPDATE (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.UIF := SR_UIF_Field (2#0#);

   end Clear_Flag_UPDATE;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC1 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC1IF := SR_CC1IF_Field (2#0#);

   end Clear_Flag_CC1;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC2 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC2IF := SR_CC2IF_Field (2#0#);

   end Clear_Flag_CC2;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC3 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC3IF := SR_CC3IF_Field (2#0#);

   end Clear_Flag_CC3;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC4 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC4IF := SR_CC4IF_Field (2#0#);

   end Clear_Flag_CC4;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TIF (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.TIF := SR_TIF_Field (2#0#);

   end Clear_Flag_TIF;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC1OVR (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC1OF := SR_CC1OF_Field (2#0#);

   end Clear_Flag_CC1OVR;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC2OVR (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC2OF := SR_CC2OF_Field (2#0#);

   end Clear_Flag_CC2OVR;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC3OVR (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC3OF := SR_CC3OF_Field (2#0#);

   end Clear_Flag_CC3OVR;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC4OVR (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SR.CC4OF := SR_CC4OF_Field (2#0#);

   end Clear_Flag_CC4OVR;

   ---------------------------------------------------------------------------
   procedure Configure_DMA_Burst (Instance     : Instance_Type;
                                  Base_Address : DMA_Burst_Base_Address_Type;
                                  Length       : DMA_Burst_Length_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DCR := (@ with delta
         DBL => DCR_DBL_Field (
            DMA_Burst_Length_Type'Pos (Length)),
         DBA => DCR_DBA_Field (
            DMA_Burst_Base_Address_Type'Pos (Base_Address)));

   end Configure_DMA_Burst;

   ---------------------------------------------------------------------------
   procedure Configure_External_Trigger (
      Instance  : Instance_Type;
      Polarity  : External_Trigger_Polarity_Type;
      Prescaler : External_Trigger_Prescaler_Type;
      Filter    : External_Trigger_Filter_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SMCR := (@ with delta
         ETP => SMCR_ETP_Field (
            External_Trigger_Polarity_Type'Pos (Polarity)),
         ETPS => SMCR_ETPS_Field (
            External_Trigger_Prescaler_Type'Pos (Prescaler)),
         ETF => SMCR_ETF_Field (
            External_Trigger_Filter_Type'Pos (Filter)));

   end Configure_External_Trigger;

   ---------------------------------------------------------------------------
   procedure Configure_Output_Compare_Output (Instance : Instance_Type;
                                              Channel  : Channel_Type;
                                              Polarity : Polarity_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));

      CCxP_Value : constant Bit := Bit (Polarity_Type'Pos (Polarity));
   begin

      case Channel is
         when CHANNEL_1 =>
            TIM_Instance.CCMR1_Output.CC1S := CCMR1_Output_CC1S_Field (2#0#);
            TIM_Instance.CCER.CC1P := CCER_CC1P_Field (CCxP_Value);
         when CHANNEL_2 =>
            TIM_Instance.CCMR1_Output.CC2S := CCMR1_Output_CC2S_Field (2#0#);
            TIM_Instance.CCER.CC2P := CCER_CC2P_Field (CCxP_Value);
         when CHANNEL_3 =>
            TIM_Instance.CCMR2_Output.CC3S := CCMR2_Output_CC3S_Field (2#0#);
            TIM_Instance.CCER.CC3P := CCER_CC3P_Field (CCxP_Value);
         when CHANNEL_4 =>
            TIM_Instance.CCMR2_Output.CC4S := CCMR2_Output_CC4S_Field (2#0#);
            TIM_Instance.CCER.CC4P := CCER_CC4P_Field (CCxP_Value);
      end case;

   end Configure_Output_Compare_Output;

   ---------------------------------------------------------------------------
   procedure Disable_Auto_Reload_Register_Preload (Instance : Instance_Type)
   is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR1.ARPE := CR1_ARPE_Field (2#0#);

   end Disable_Auto_Reload_Register_Preload;

   ---------------------------------------------------------------------------
   procedure Disable_Capture_Compare_Channel (Instance : Instance_Type;
                                              Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCER.CC1E := CCER_CC1E_Field (2#0#);
         when CHANNEL_2 => TIM_Instance.CCER.CC2E := CCER_CC2E_Field (2#0#);
         when CHANNEL_3 => TIM_Instance.CCER.CC3E := CCER_CC3E_Field (2#0#);
         when CHANNEL_4 => TIM_Instance.CCER.CC4E := CCER_CC4E_Field (2#0#);
      end case;

   end Disable_Capture_Compare_Channel;

   ---------------------------------------------------------------------------
   procedure Disable_Counter (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR1.CEN := CR1_CEN_Field (2#0#);

   end Disable_Counter;

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_UPDATE (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.UDE := DIER_UDE_Field (2#0#);

   end Disable_DMA_Request_UPDATE;

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC1 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC1DE := DIER_CC1DE_Field (2#0#);

   end Disable_DMA_Request_CC1;

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC2 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC2DE := DIER_CC2DE_Field (2#0#);

   end Disable_DMA_Request_CC2;

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC3 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC3DE := DIER_CC3DE_Field (2#0#);

   end Disable_DMA_Request_CC3;

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC4 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC4DE := DIER_CC4DE_Field (2#0#);

   end Disable_DMA_Request_CC4;

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_TRIG (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.TDE := DIER_TDE_Field (2#0#);

   end Disable_DMA_Request_TRIG;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_UPDATE (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.UIE := DIER_UIE_Field (2#0#);

   end Disable_Interrupt_UPDATE;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC1 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC1IE := DIER_CC1IE_Field (2#0#);

   end Disable_Interrupt_CC1;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC2 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC2IE := DIER_CC2IE_Field (2#0#);

   end Disable_Interrupt_CC2;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC3 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC3IE := DIER_CC3IE_Field (2#0#);

   end Disable_Interrupt_CC3;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC4 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC4IE := DIER_CC4IE_Field (2#0#);

   end Disable_Interrupt_CC4;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_TRIG (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.TIE := DIER_TIE_Field (2#0#);

   end Disable_Interrupt_TRIG;

   ---------------------------------------------------------------------------
   procedure Disable_Master_Slave_Mode (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SMCR.MSM := SMCR_MSM_Field (2#0#);

   end Disable_Master_Slave_Mode;

   ---------------------------------------------------------------------------
   procedure Disable_Output_Compare_Clear (Instance : Instance_Type;
                                           Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCMR1_Output.OC1CE :=
            CCMR1_Output_OC1CE_Field (2#0#);
         when CHANNEL_2 => TIM_Instance.CCMR1_Output.OC2CE :=
            CCMR1_Output_OC2CE_Field (2#0#);
         when CHANNEL_3 => TIM_Instance.CCMR2_Output.OC3CE :=
            CCMR2_Output_OC3CE_Field (2#0#);
         when CHANNEL_4 => TIM_Instance.CCMR2_Output.OC4CE :=
            CCMR2_Output_OC4CE_Field (2#0#);
      end case;

   end Disable_Output_Compare_Clear;

   ---------------------------------------------------------------------------
   procedure Disable_Output_Compare_Fast_Mode (Instance : Instance_Type;
                                               Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCMR1_Output.OC1FE :=
            CCMR1_Output_OC1FE_Field (2#0#);
         when CHANNEL_2 => TIM_Instance.CCMR1_Output.OC2FE :=
            CCMR1_Output_OC2FE_Field (2#0#);
         when CHANNEL_3 => TIM_Instance.CCMR2_Output.OC3FE :=
            CCMR2_Output_OC3FE_Field (2#0#);
         when CHANNEL_4 => TIM_Instance.CCMR2_Output.OC4FE :=
            CCMR2_Output_OC4FE_Field (2#0#);
      end case;

   end Disable_Output_Compare_Fast_Mode;

   ---------------------------------------------------------------------------
   procedure Disable_Output_Compare_Preload (Instance : Instance_Type;
                                             Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCMR1_Output.OC1PE :=
            CCMR1_Output_OC1PE_Field (2#0#);
         when CHANNEL_2 => TIM_Instance.CCMR1_Output.OC2PE :=
            CCMR1_Output_OC2PE_Field (2#0#);
         when CHANNEL_3 => TIM_Instance.CCMR2_Output.OC3PE :=
            CCMR2_Output_OC3PE_Field (2#0#);
         when CHANNEL_4 => TIM_Instance.CCMR2_Output.OC4PE :=
            CCMR2_Output_OC4PE_Field (2#0#);
      end case;

   end Disable_Output_Compare_Preload;

   ---------------------------------------------------------------------------
   procedure Disable_Update_Event (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin


      TIM_Instance.CR1.UDIS := CR1_UDIS_Field (2#1#);


   end Disable_Update_Event;

   ---------------------------------------------------------------------------
   procedure Enable_Auto_Reload_Register_Preload (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR1.ARPE := CR1_ARPE_Field (2#1#);

   end Enable_Auto_Reload_Register_Preload;

   ---------------------------------------------------------------------------
   procedure Enable_Capture_Compare_Channel (Instance : Instance_Type;
                                             Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCER.CC1E := CCER_CC1E_Field (2#1#);
         when CHANNEL_2 => TIM_Instance.CCER.CC2E := CCER_CC2E_Field (2#1#);
         when CHANNEL_3 => TIM_Instance.CCER.CC3E := CCER_CC3E_Field (2#1#);
         when CHANNEL_4 => TIM_Instance.CCER.CC4E := CCER_CC4E_Field (2#1#);
      end case;

   end Enable_Capture_Compare_Channel;

   ---------------------------------------------------------------------------
   procedure Enable_Counter (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR1.CEN := CR1_CEN_Field (2#1#);

   end Enable_Counter;

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_UPDATE (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.UDE := DIER_UDE_Field (2#1#);

   end Enable_DMA_Request_UPDATE;

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC1 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC1DE := DIER_CC1DE_Field (2#1#);

   end Enable_DMA_Request_CC1;

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC2 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC2DE := DIER_CC2DE_Field (2#1#);

   end Enable_DMA_Request_CC2;

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC3 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC3DE := DIER_CC3DE_Field (2#1#);

   end Enable_DMA_Request_CC3;

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC4 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC4DE := DIER_CC4DE_Field (2#1#);

   end Enable_DMA_Request_CC4;

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_TRIG (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.TDE := DIER_TDE_Field (2#1#);

   end Enable_DMA_Request_TRIG;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_UPDATE (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.UIE := DIER_UIE_Field (2#1#);

   end Enable_Interrupt_UPDATE;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC1 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC1IE := DIER_CC1IE_Field (2#1#);

   end Enable_Interrupt_CC1;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC2 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC2IE := DIER_CC2IE_Field (2#1#);

   end Enable_Interrupt_CC2;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC3 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC3IE := DIER_CC3IE_Field (2#1#);

   end Enable_Interrupt_CC3;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC4 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.CC4IE := DIER_CC4IE_Field (2#1#);

   end Enable_Interrupt_CC4;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_TRIG (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.DIER.TIE := DIER_TIE_Field (2#1#);

   end Enable_Interrupt_TRIG;

   ---------------------------------------------------------------------------
   procedure Enable_Master_Slave_Mode (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SMCR.MSM := SMCR_MSM_Field (2#1#);

   end Enable_Master_Slave_Mode;

   ---------------------------------------------------------------------------
   procedure Enable_Output_Compare_Clear (Instance : Instance_Type;
                                          Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCMR1_Output.OC1CE :=
            CCMR1_Output_OC1CE_Field (2#1#);
         when CHANNEL_2 => TIM_Instance.CCMR1_Output.OC2CE :=
            CCMR1_Output_OC2CE_Field (2#1#);
         when CHANNEL_3 => TIM_Instance.CCMR2_Output.OC3CE :=
            CCMR2_Output_OC3CE_Field (2#1#);
         when CHANNEL_4 => TIM_Instance.CCMR2_Output.OC4CE :=
            CCMR2_Output_OC4CE_Field (2#1#);
      end case;

   end Enable_Output_Compare_Clear;

   ---------------------------------------------------------------------------
   procedure Enable_Output_Compare_Fast_Mode (Instance : Instance_Type;
                                              Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCMR1_Output.OC1FE :=
            CCMR1_Output_OC1FE_Field (2#1#);
         when CHANNEL_2 => TIM_Instance.CCMR1_Output.OC2FE :=
            CCMR1_Output_OC2FE_Field (2#1#);
         when CHANNEL_3 => TIM_Instance.CCMR2_Output.OC3FE :=
            CCMR2_Output_OC3FE_Field (2#1#);
         when CHANNEL_4 => TIM_Instance.CCMR2_Output.OC4FE :=
            CCMR2_Output_OC4FE_Field (2#1#);
      end case;

   end Enable_Output_Compare_Fast_Mode;

   ---------------------------------------------------------------------------
   procedure Enable_Output_Compare_Preload (Instance : Instance_Type;
                                            Channel  : Channel_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 => TIM_Instance.CCMR1_Output.OC1PE :=
            CCMR1_Output_OC1PE_Field (2#1#);
         when CHANNEL_2 => TIM_Instance.CCMR1_Output.OC2PE :=
            CCMR1_Output_OC2PE_Field (2#1#);
         when CHANNEL_3 => TIM_Instance.CCMR2_Output.OC3PE :=
            CCMR2_Output_OC3PE_Field (2#1#);
         when CHANNEL_4 => TIM_Instance.CCMR2_Output.OC4PE :=
            CCMR2_Output_OC4PE_Field (2#1#);
      end case;

   end Enable_Output_Compare_Preload;

   ---------------------------------------------------------------------------
   procedure Enable_Update_Event (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR1.UDIS := CR1_UDIS_Field (2#0#);

   end Enable_Update_Event;

   ---------------------------------------------------------------------------
   procedure Generate_Event_UPDATE (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.EGR.UG := EGR_UG_Field (2#1#);

   end Generate_Event_UPDATE;

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC1 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.EGR.CC1G := EGR_CC1G_Field (2#1#);

   end Generate_Event_CC1;

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC2 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.EGR.CC2G := EGR_CC2G_Field (2#1#);

   end Generate_Event_CC2;

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC3 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.EGR.CC3G := EGR_CC3G_Field (2#1#);

   end Generate_Event_CC3;

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC4 (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.EGR.CC4G := EGR_CC4G_Field (2#1#);

   end Generate_Event_CC4;

   ---------------------------------------------------------------------------
   procedure Generate_Event_TRIG (Instance : Instance_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.EGR.TG := EGR_TG_Field (2#1#);

   end Generate_Event_TRIG;

   ---------------------------------------------------------------------------
   function Get_Output_Compare_Compare (Instance : Instance_Type;
                                        Channel  : Channel_Type)
      return Compare_Type is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));

      Compare_Value : Compare_Type;
   begin

      Compare_Value := Compare_Type (case Channel is
         when CHANNEL_1 => TIM_Instance.CCR1.CCR1_L,
         when CHANNEL_2 => TIM_Instance.CCR2.CCR2_L,
         when CHANNEL_3 => TIM_Instance.CCR3.CCR3_L,
         when CHANNEL_4 => TIM_Instance.CCR4.CCR4_L);

      return Compare_Value;

   end Get_Output_Compare_Compare;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_UPDATE (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.UIF);

   end Is_Active_Flag_UPDATE;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC1 (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC1IF);

   end Is_Active_Flag_CC1;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC2 (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC2IF);

   end Is_Active_Flag_CC2;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC3 (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC3IF);

   end Is_Active_Flag_CC3;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC4 (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC4IF);

   end Is_Active_Flag_CC4;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TRIG (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.TIF);

   end Is_Active_Flag_TRIG;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC1OVR (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC1OF);

   end Is_Active_Flag_CC1OVR;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC2OVR (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC2OF);

   end Is_Active_Flag_CC2OVR;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC3OVR (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC3OF);

   end Is_Active_Flag_CC3OVR;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC4OVR (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.SR.CC4OF);

   end Is_Active_Flag_CC4OVR;

   ---------------------------------------------------------------------------
   function Is_Enabled_Auto_Reload_Register_Preload (Instance : Instance_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      return Boolean'Enum_Val (TIM_Instance.CR1.ARPE);

   end Is_Enabled_Auto_Reload_Register_Preload;

   ---------------------------------------------------------------------------
   function Is_Enabled_Capture_Compare_Channel (Instance : Instance_Type;
                                                Channel  : Channel_Type)
      return Boolean is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));

      Status : Boolean;
   begin

      Status := (case Channel is
         when CHANNEL_1 => Boolean'Enum_Val (TIM_Instance.CCER.CC1E),
         when CHANNEL_2 => Boolean'Enum_Val (TIM_Instance.CCER.CC2E),
         when CHANNEL_3 => Boolean'Enum_Val (TIM_Instance.CCER.CC3E),
         when CHANNEL_4 => Boolean'Enum_Val (TIM_Instance.CCER.CC4E));

      return Status;

   end Is_Enabled_Capture_Compare_Channel;

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
   procedure Set_Auto_Reload (Instance    : Instance_Type;
                              Auto_Reload : Auto_Reload_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.ARR.ARR_L := ARR_ARR_L_Field (Auto_Reload);

   end Set_Auto_Reload;

   ---------------------------------------------------------------------------
   procedure Set_Counter (Instance : Instance_Type;
                          Counter  : Counter_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CNT.CNT_L := CNT_CNT_L_Field (Counter);

   end Set_Counter;

   ---------------------------------------------------------------------------
   procedure Set_Clock_Division (Instance       : Instance_Type;
                                 Clock_Division : Clock_Division_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR1.CKD := CR1_CKD_Field (
         Clock_Division_Type'Pos (Clock_Division));

   end Set_Clock_Division;

   ---------------------------------------------------------------------------
   procedure Set_Clock_Source (Instance     : Instance_Type;
                               Clock_Source : Clock_Source_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SMCR := (@ with delta
         SMS => SMCR_SMS_Field (
            if Clock_Source = EXT_MODE1 then 2#111# else 2#0#),
         ECE => SMCR_ECE_Field (
            if Clock_Source = EXT_MODE2 then 2#1# else 2#0#));

   end Set_Clock_Source;

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
   procedure Set_DMA_Request_Trigger (Instance    : Instance_Type;
                                      DMA_Trigger : DMA_Trigger_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR2.CCDS := CR2_CCDS_Field (
         DMA_Trigger_Type'Pos (DMA_Trigger));

   end Set_DMA_Request_Trigger;

   ---------------------------------------------------------------------------
   procedure Set_Encoder_Mode (Instance     : Instance_Type;
                               Encoder_Mode : Encoder_Mode_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SMCR.SMS :=
         SMCR_SMS_Field (Encoder_Mode_Type'Pos (Encoder_Mode));

   end Set_Encoder_Mode;

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
   procedure Set_Output_Compare_Compare (Instance : Instance_Type;
                                         Channel  : Channel_Type;
                                         Compare  : Compare_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      case Channel is
         when CHANNEL_1 =>
            TIM_Instance.CCR1.CCR1_L := CCR1_CCR1_L_Field (Compare);
         when CHANNEL_2 =>
            TIM_Instance.CCR2.CCR2_L := CCR2_CCR2_L_Field (Compare);
         when CHANNEL_3 =>
            TIM_Instance.CCR3.CCR3_L := CCR3_CCR3_L_Field (Compare);
         when CHANNEL_4 =>
            TIM_Instance.CCR4.CCR4_L := CCR4_CCR4_L_Field (Compare);
      end case;

   end Set_Output_Compare_Compare;

   ---------------------------------------------------------------------------
   procedure Set_Output_Compare_Mode (Instance : Instance_Type;
                                      Channel  : Channel_Type;
                                      Mode     : Output_Compare_Mode_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));

      CCxM_Value : constant UInt3 := UInt3 (
         Output_Compare_Mode_Type'Pos (Mode));
      --
   begin

      case Channel is
         when CHANNEL_1 =>
            TIM_Instance.CCMR1_Output.CC1S := CCMR1_Output_CC1S_Field (2#0#);
            TIM_Instance.CCMR1_Output.OC1M :=
               CCMR1_Output_OC1M_Field (CCxM_Value);
         when CHANNEL_2 =>
            TIM_Instance.CCMR1_Output.CC2S := CCMR1_Output_CC2S_Field (2#0#);
            TIM_Instance.CCMR1_Output.OC2M :=
               CCMR1_Output_OC2M_Field (CCxM_Value);
         when CHANNEL_3 =>
            TIM_Instance.CCMR2_Output.CC3S := CCMR2_Output_CC3S_Field (2#0#);
            TIM_Instance.CCMR2_Output.OC3M :=
               CCMR2_Output_OC3M_Field (CCxM_Value);
         when CHANNEL_4 =>
            TIM_Instance.CCMR2_Output.CC4S := CCMR2_Output_CC4S_Field (2#0#);
            TIM_Instance.CCMR2_Output.OC4M :=
               CCMR2_Output_OC4M_Field (CCxM_Value);
      end case;

   end Set_Output_Compare_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Output_Compare_Polarity (Instance : Instance_Type;
                                          Channel  : Channel_Type;
                                          Polarity : Polarity_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));

      CCxP_Value : constant Bit := Bit (Polarity_Type'Pos (Polarity));
   begin

      case Channel is
         when CHANNEL_1 =>
            TIM_Instance.CCER.CC1P := CCER_CC1P_Field (CCxP_Value);
         when CHANNEL_2 =>
            TIM_Instance.CCER.CC2P := CCER_CC2P_Field (CCxP_Value);
         when CHANNEL_3 =>
            TIM_Instance.CCER.CC3P := CCER_CC3P_Field (CCxP_Value);
         when CHANNEL_4 =>
            TIM_Instance.CCER.CC4P := CCER_CC4P_Field (CCxP_Value);
      end case;

   end Set_Output_Compare_Polarity;

   ---------------------------------------------------------------------------
   procedure Set_Prescaler (Instance  : Instance_Type;
                            Prescaler : Prescaler_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.PSC.PSC := PSC_PSC_Field (Natural (Prescaler) - 1);

   end Set_Prescaler;

   ---------------------------------------------------------------------------
   procedure Set_Slave_Mode (Instance   : Instance_Type;
                             Slave_Mode : Slave_Mode_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SMCR.SMS := SMCR_SMS_Field (case Slave_Mode is
         when DISABLED => 2#0#,
         when others => Slave_Mode_Type'Pos (Slave_Mode) + 2#011#);

   end Set_Slave_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Trigger_Input (Instance      : Instance_Type;
                                Trigger_Input : Trigger_Input_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.SMCR.TS :=
         SMCR_TS_Field (Trigger_Input_Type'Pos (Trigger_Input));

   end Set_Trigger_Input;

   ---------------------------------------------------------------------------
   procedure Set_Trigger_Output (Instance       : Instance_Type;
                                 Trigger_Output : Trigger_Output_Type) is
      --
      TIM_Instance
         renames TIMx (All_Instance_Type (Instance));
   begin

      TIM_Instance.CR2.MMS :=
         CR2_MMS_Field (Trigger_Output_Type'Pos (Trigger_Output));

   end Set_Trigger_Output;

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