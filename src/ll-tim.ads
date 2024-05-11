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
   use all type CMSIS.Device.TIM.Instances.Channel_Type;
   use all type CMSIS.Device.TIM.Instances.Instance_Type;

package LL.TIM is
   --  Timer (TIM) low-layer driver
   --
   --  TODO:
   --  - Implement Set_Remap
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_tim.h

   subtype Instance_Type is
      CMSIS.Device.TIM.Instances.Instance_Type;
   --

   subtype Channel_Type is
      CMSIS.Device.TIM.Instances.Channel_Type;
   --

   type Clock_Division_Type is
      (DIV1, DIV2, DIV4)
      with Default_Value => DIV1;
   --
   --  @enum DIV1 tDTS equals tCK_INT
   --  @enum DIV2 tDTS equals tCK_INT * 2
   --  @enum DIV4 tDTS equals tCK_INT * 4

   type Clock_Source_Type is
      (INTERNAL, EXT_MODE1, EXT_MODE2)
      with Default_Value => INTERNAL;
   --
   --  @enum INTERNAL The timer is clocked by the internal clock provided
   --    from the RCC
   --  @enum EXT_MODE1 Counter counts at each rising or falling edge on a
   --    selected input
   --  @enum EXT_MODE2 Counter counts at each rising or falling edge on the
   --    external trigger input ETR

   subtype Counter_Type is
      Natural range 0 .. 16#FFFF#;
   --  Counter value

   subtype Auto_Reload_Type is
      Counter_Type;
   --

   subtype Compare_Type is
      Counter_Type;
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

   type DMA_Burst_Base_Address_Type is
      (CR1R, CR2R, SMCRR, DIERR, SRR, EGRR, CCMR1R, CCMR2R, CCERR, CNTR, PSCR,
         ARRR, CCR1R, CCR2R, CCR3R, CCR4R, ORR)
      with Default_Value => CR1R;
   --
   --  @enum CR1R TIMx_CR1 register is the DMA base address for DMA burst
   --  @enum CR2R TIMx_CR2 register is the DMA base address for DMA burst
   --  @enum SMCRR TIMx_SMCR register is the DMA base address for DMA burst
   --  @enum DIERR TIMx_DIER register is the DMA base address for DMA burst
   --  @enum SRR TIMx_SR register is the DMA base address for DMA burst
   --  @enum EGRR TIMx_EGR register is the DMA base address for DMA burst
   --  @enum CCMR1R TIMx_CCMR1 register is the DMA base address for DMA burst
   --  @enum CCMR2R TIMx_CCMR2 register is the DMA base address for DMA burst
   --  @enum CCERR TIMx_CCER register is the DMA base address for DMA burst
   --  @enum CNTR TIMx_CNT register is the DMA base address for DMA burst
   --  @enum PSCR TIMx_PSC register is the DMA base address for DMA burst
   --  @enum ARRR TIMx_ARR register is the DMA base address for DMA burst
   --  @enum CCR1R TIMx_CCR1 register is the DMA base address for DMA burst
   --  @enum CCR2R TIMx_CCR2 register is the DMA base address for DMA burst
   --  @enum CCR3R TIMx_CCR3 register is the DMA base address for DMA burst
   --  @enum CCR4R TIMx_CCR4 register is the DMA base address for DMA burst
   --  @enum ORR TIMx_OR register is the DMA base address for DMA burst

   type DMA_Burst_Length_Type is
      (N_1, N_2, N_3, N_4, N_5, N_6, N_7, N_8, N_9, N_10, N_11, N_12, N_13,
         N_14, N_15, N_16, N_17, N_18)
      with Default_Value => N_1;
   --
   --  @enum N_1 1 transfer starting from the DMA burst base address
   --  @enum N_2 2 transfers starting from the DMA burst base address
   --  @enum N_3 3 transfers starting from the DMA burst base address
   --  @enum N_4 4 transfers starting from the DMA burst base address
   --  @enum N_5 5 transfers starting from the DMA burst base address
   --  @enum N_6 6 transfers starting from the DMA burst base address
   --  @enum N_7 7 transfers starting from the DMA burst base address
   --  @enum N_8 1 transfers starting from the DMA burst base address
   --  @enum N_9 9 transfers starting from the DMA burst base address
   --  @enum N_10 10 transfers starting from the DMA burst base address
   --  @enum N_11 11 transfers starting from the DMA burst base address
   --  @enum N_12 12 transfers starting from the DMA burst base address
   --  @enum N_13 13 transfers starting from the DMA burst base address
   --  @enum N_14 14 transfers starting from the DMA burst base address
   --  @enum N_15 15 transfers starting from the DMA burst base address
   --  @enum N_16 16 transfers starting from the DMA burst base address
   --  @enum N_17 17 transfers starting from the DMA burst base address
   --  @enum N_18 18 transfers starting from the DMA burst base address

   type DMA_Trigger_Type is
      (CC, UPDATE)
      with Default_Value => CC;
   --  Capture Compare DMA Request
   --
   --  @enum CC Request sent when CCx event occurs
   --  @enum UPDATE Requests sent when update event occurs

   type Encoder_Mode_Type is
      (X2_TI1, X2_TI2, X4_TI12)
      with Default_Value => X2_TI1;
   --  Encoder mode
   --
   --  @enum X2_TI1 Quadrature encoder mode 1, x2 mode - Counter counts
   --    up/down on TI1FP1 edge depending on TI2FP2 level
   --  @enum X2_TI2 Quadrature encoder mode 2, x2 mode - Counter counts
   --    up/down on TI2FP2 edge depending on TI1FP1 level
   --  @enum X4_TI12 Quadrature encoder mode 3, x4 mode - Counter counts
   --    up/down on both TI1FP1 and TI2FP2 edges depending on the level of
   --    the other input

   type External_Trigger_Polarity_Type is
      (NONINVERTED, INVERTED)
      with Default_Value => NONINVERTED;
   --
   --  @enum NONINVERTED External trigger non-inverted, active at high level
   --    or rising edge
   --  @enum INVERTED External trigger inverted, active at low level or
   --    falling edge

   type External_Trigger_Prescaler_Type is
      (DIV1, DIV2, DIV4, DIV8)
      with Default_Value => DIV1;
   --
   --  @enum DIV1 External trigger prescaler OFF
   --  @enum DIV2 External trigger frequency is divided by 2
   --  @enum DIV4 External trigger frequency is divided by 4
   --  @enum DIV8 External trigger frequency is divided by 8

   type External_Trigger_Filter_Type is
      (FDIV1, FDIV1_N2, FDIV1_N4, FDIV1_N8, FDIV2_N6, FDIV2_N8, FDIV4_N6,
         FDIV4_N8, FDIV8_N6, FDIV8_N8, FDIV16_N5, FDIV16_N6, FDIV16_N8,
         FDIV32_N5, FDIV32_N6, FDIV32_N8)
      with Default_Value => FDIV1;
   --
   --  @enum FDIV1 No filter, sampling is done at fDTS
   --  @enum FDIV1_N2 fSAMPLING=fCK_INT, N=2
   --  @enum FDIV1_N4 fSAMPLING=fCK_INT, N=4
   --  @enum FDIV1_N8 fSAMPLING=fCK_INT, N=8
   --  @enum FDIV2_N6 fSAMPLING=fDTS/2, N=6
   --  @enum FDIV2_N8 fSAMPLING=fDTS/2, N=8
   --  @enum FDIV4_N6 fSAMPLING=fDTS/4, N=6
   --  @enum FDIV4_N8 fSAMPLING=fDTS/4, N=8
   --  @enum FDIV8_N6 fSAMPLING=fDTS/8, N=8
   --  @enum FDIV8_N8 fSAMPLING=fDTS/16, N=5
   --  @enum FDIV16_N5 fSAMPLING=fDTS/16, N=6
   --  @enum FDIV16_N6 fSAMPLING=fDTS/16, N=8
   --  @enum FDIV16_N8 fSAMPLING=fDTS/16, N=5
   --  @enum FDIV32_N5 fSAMPLING=fDTS/32, N=5
   --  @enum FDIV32_N6 fSAMPLING=fDTS/32, N=6
   --  @enum FDIV32_N8 fSAMPLING=fDTS/32, N=8

   type One_Pulse_Mode_Type is
      (REPETITIVE, SINGLE)
      with Default_Value => REPETITIVE;
   --
   --  @enum REPETITIVE Counter is not stopped at update event
   --  @enum SINGLE Counter stops counting at the next update event

   type Output_Compare_Mode_Type is
      (FROZEN, ACTIVE, INACTIVE, TOGGLE, FORCED_INACTIVE, FORCED_ACTIVE, PWM1,
         PWM2)
      with Default_Value => FROZEN;
   --
   --  @enum FROZEN The comparison between the output compare register and the
   --    counter has no effect on the output channel level
   --  @enum ACTIVE The output channel is forced high on compare match
   --  @enum INACTIVE The output channel is forced low on compare match
   --  @enum TOGGLE The output channel toggles on compare match
   --  @enum FORCED_INACTIVE The output channel is forced low
   --  @enum FORCED_ACTIVE The output channel is forced high
   --  @enum PWM1 In up-counting, the channel is active as long as the counter
   --    is lower than the compare register, else inactive. In down-counting,
   --    the behaviour is reversed
   --  @enum PWM2 In up-counting, the channel is inactive as long as the
   --    counter is higher than the compare register, else active. In
   --    down-counting, the behaviour is reversed

   type Polarity_Type is
      (HIGH, LOW)
      with Default_Value => HIGH;
   --  Output Configuration Polarity
   --
   --  @enum HIGH Active high
   --  @enum LOW Active low

   subtype Prescaler_Type is
      Positive range 1 .. 16#10000#;
   --  Prescaler value

   type Slave_Mode_Type is
      (DISABLED, RESET, GATED, TRIGGER)
      with Default_Value => DISABLED;
   --
   --  @enum DISABLED Slave mode disabled
   --  @enum RESET Rising edge of the selected trigger input reinitializes
   --    the counter
   --  @enum GATED The counter clock is enabled when the trigger input is high
   --  @enum TRIGGER The counter starts at a rising edge of the trigger

   type Trigger_Input_Type is
      (ITR0, ITR1, ITR2, ITR3, TI1F_ED, TI1FP1, TI2FP2, ETRF)
      with Default_Value => ITR0;
   --
   --  @enum ITR0 Internal Trigger 0 is used as trigger input
   --  @enum ITR1 Internal Trigger 1 is used as trigger input
   --  @enum ITR2 Internal Trigger 2 is used as trigger input
   --  @enum ITR3 Internal Trigger 3 is used as trigger input
   --  @enum TI1F_ED TI1 Edge Detector is used as trigger input
   --  @enum TI1FP1 Filtered Timer Input 1 is used as trigger input
   --  @enum TI2FP2 Filtered Timer Input 2  is used as trigger input
   --  @enum ETRF Filtered external Trigger is used as trigger input

   type Trigger_Output_Type is
      (RESET, ENABLE, UPDATE, CC1IF, OC1REF, OC2REF, OC3REF, OC4REF)
      with Default_Value => RESET;
   --  Trigger output
   --
   --  @enum RESET UG bit from the TIMx_EGR register is used as trigger output
   --  @enum ENABLE Counter Enable signal (CNT_EN) is used as trigger output
   --  @enum UPDATE Update event is used as trigger output
   --  @enum CC1IF CC1 capture or a compare match is used as trigger output
   --  @enum OC1REF OC1REF signal is used as trigger output
   --  @enum OC2REF OC2REF signal is used as trigger output
   --  @enum OC3REF OC3REF signal is used as trigger output
   --  @enum OC4REF OC4REF signal is used as trigger output

   type Update_Source_Type is
      (REGULAR, COUNTER)
      with Default_Value => REGULAR;
   --
   --  @enum REGULAR Counter overflow/underflow, Setting the UG bit or Update
   --    generation through the slave mode controller
   --  @enum COUNTER Only counter overflow/underflow generates a request

   ---------------------------------------------------------------------------
   procedure Clear_Flag_UPDATE (Instance : Instance_Type);
   --  Clear the Update interrupt flag (UIF)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC1 (Instance : Instance_Type);
   --  Clear the Capture/Compare 1 interrupt flag (CC1F)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC2 (Instance : Instance_Type);
   --  Clear the Capture/Compare 2 interrupt flag (CC2F)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC3 (Instance : Instance_Type);
   --  Clear the Capture/Compare 3 interrupt flag (CC3F)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC4 (Instance : Instance_Type);
   --  Clear the Capture/Compare 4 interrupt flag (CC4F)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TIF (Instance : Instance_Type);
   --  Clear the Trigger interrupt flag (TIF)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC1OVR (Instance : Instance_Type);
   --  Clear the Capture/Compare 1 over-capture interrupt flag (CC1OF)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC2OVR (Instance : Instance_Type);
   --  Clear the Capture/Compare 2 over-capture interrupt flag (CC2OF)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC3OVR (Instance : Instance_Type);
   --  Clear the Capture/Compare 3 over-capture interrupt flag (CC3OF)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CC4OVR (Instance : Instance_Type);
   --  Clear the Capture/Compare 4 over-capture interrupt flag (CC4OF)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Configure_DMA_Burst (Instance     : Instance_Type;
                                  Base_Address : DMA_Burst_Base_Address_Type;
                                  Length       : DMA_Burst_Length_Type);
   --  Configures the timer DMA burst feature
   --
   --  Notes:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_DMABURST_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Base_Address DMA Burst Base Address
   --  @param Length DMA Burst Length

   ---------------------------------------------------------------------------
   procedure Configure_External_Trigger (
      Instance  : Instance_Type;
      Polarity  : External_Trigger_Polarity_Type;
      Prescaler : External_Trigger_Prescaler_Type;
      Filter    : External_Trigger_Filter_Type);
   --  Configure the external trigger (ETR) input.
   --
   --  @param Instance TIM peripheral instance
   --  @param Polarity Polarity
   --  @param Prescaler Prescaler
   --  @param Filter Filter

   ---------------------------------------------------------------------------
   procedure Configure_Output_Compare_Output (Instance : Instance_Type;
                                              Channel  : Channel_Type;
                                              Polarity : Polarity_Type);
   --  Output channel configuration
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance
   --  @param Polarity Polarity

   ---------------------------------------------------------------------------
   procedure Disable_Auto_Reload_Register_Preload (Instance : Instance_Type);
   --  Disable auto-reload register (ARR) preload
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Capture_Compare_Channel (Instance : Instance_Type;
                                              Channel  : Channel_Type);
   --  Disable capture/compare channels
   --
   --  Notes:
   --  - Differently from the reference implementation
   --    LL_TIM_CC_DisableChannel, this procedure handles a single channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Disable_Counter (Instance : Instance_Type);
   --  Disable timer counter
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_UPDATE (Instance : Instance_Type);
   --  Disable update DMA request (UDE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC1 (Instance : Instance_Type);
   --  Disable capture/compare 1 DMA request (CC1DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC2 (Instance : Instance_Type);
   --  Disable capture/compare 2 DMA request (CC2DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC3 (Instance : Instance_Type);
   --  Disable capture/compare 3 DMA request (CC3DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_CC4 (Instance : Instance_Type);
   --  Disable capture/compare 4 DMA request (CC4DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_DMA_Request_TRIG (Instance : Instance_Type);
   --  Disable trigger DMA request (TDE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_UPDATE (Instance : Instance_Type);
   --  Disable update interrupt (UIE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC1 (Instance : Instance_Type);
   --  Disable capture/compare 1 interrupt (CC1IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC2 (Instance : Instance_Type);
   --  Disable capture/compare 2 interrupt (CC2IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC3 (Instance : Instance_Type);
   --  Disable capture/compare 3 interrupt (CC3IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CC4 (Instance : Instance_Type);
   --  Disable capture/compare 4 interrupt (CC4IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_TRIG (Instance : Instance_Type);
   --  Disable trigger interrupt (TIE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Master_Slave_Mode (Instance : Instance_Type);
   --  Disable the Master/Slave mode
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_SLAVE_INSTANCE
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Output_Compare_Clear (Instance : Instance_Type;
                                           Channel  : Channel_Type);
   --  Disable clearing the output channel on an external event
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_OCXREF_CLEAR_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Disable_Output_Compare_Fast_Mode (Instance : Instance_Type;
                                               Channel  : Channel_Type);
   --  Disable fast mode for the output channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Disable_Output_Compare_Preload (Instance : Instance_Type;
                                             Channel  : Channel_Type);
   --  Disable compare register preload for the output channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Disable_Update_Event (Instance : Instance_Type);
   --  Disable update event generation
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Auto_Reload_Register_Preload (Instance : Instance_Type);
   --  Enable auto-reload register (ARR) preload
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Capture_Compare_Channel (Instance : Instance_Type;
                                             Channel  : Channel_Type);
   --  Enable capture/compare channels
   --
   --  Notes:
   --  - Differently from the reference implementation
   --    LL_TIM_CC_EnableChannel, this procedure handles a single channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Enable_Counter (Instance : Instance_Type);
   --  Enable timer counter
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_UPDATE (Instance : Instance_Type);
   --  Enable update DMA request (UDE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC1 (Instance : Instance_Type);
   --  Enable capture/compare 1 DMA request (CC1DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC2 (Instance : Instance_Type);
   --  Enable capture/compare 2 DMA request (CC2DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC3 (Instance : Instance_Type);
   --  Enable capture/compare 3 DMA request (CC3DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_CC4 (Instance : Instance_Type);
   --  Enable capture/compare 4 DMA request (CC4DE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_DMA_Request_TRIG (Instance : Instance_Type);
   --  Enable trigger DMA request (TDE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_UPDATE (Instance : Instance_Type);
   --  Enable update interrupt (UIE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC1 (Instance : Instance_Type);
   --  Enable capture/compare 1 interrupt (CC1IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC2 (Instance : Instance_Type);
   --  Enable capture/compare 2 interrupt (CC2IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC3 (Instance : Instance_Type);
   --  Enable capture/compare 3 interrupt (CC3IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CC4 (Instance : Instance_Type);
   --  Enable capture/compare 4 interrupt (CC4IE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_TRIG (Instance : Instance_Type);
   --  Enable trigger interrupt (TIE)
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Master_Slave_Mode (Instance : Instance_Type);
   --  Enable the Master/Slave mode
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_SLAVE_INSTANCE
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Output_Compare_Clear (Instance : Instance_Type;
                                          Channel  : Channel_Type);
   --  Enable clearing the output channel on an external event
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_OCXREF_CLEAR_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Enable_Output_Compare_Fast_Mode (Instance : Instance_Type;
                                              Channel  : Channel_Type);
   --  Enable fast mode for the output channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Enable_Output_Compare_Preload (Instance : Instance_Type;
                                            Channel  : Channel_Type);
   --  Enable compare register preload for the output channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance

   ---------------------------------------------------------------------------
   procedure Enable_Update_Event (Instance : Instance_Type);
   --  Enable update event generation
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Generate_Event_UPDATE (Instance : Instance_Type);
   --  Generate update event
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC1 (Instance : Instance_Type);
   --  Generate capture/compare 1 event
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC2 (Instance : Instance_Type);
   --  Generate capture/compare 2 event
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC3 (Instance : Instance_Type);
   --  Generate capture/compare 3 event
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Generate_Event_CC4 (Instance : Instance_Type);
   --  Generate capture/compare 4 event
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   procedure Generate_Event_TRIG (Instance : Instance_Type);
   --  Generate trigger event
   --
   --  @param Instance TIM peripheral instance

   ---------------------------------------------------------------------------
   function Get_Output_Compare_Compare (Instance : Instance_Type;
                                        Channel  : Channel_Type)
      return Compare_Type;
   --  Get compare value for output channel
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --     IS_TIM_CC1_INSTANCE, IS_TIM_CC2_INSTANCE, IS_TIM_CC3_INSTANCE,
   --     IS_TIM_CC4_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance
   --  @return Compare value

   ---------------------------------------------------------------------------
   function Is_Active_Flag_UPDATE (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Update interrupt flag (UIF) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC1 (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 1 interrupt flag (CC1F) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC2 (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 2 interrupt flag (CC2F) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC3 (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 3 interrupt flag (CC3F) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC4 (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 4 interrupt flag (CC4F) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TRIG (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Trigger interrupt flag (TIF) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC1OVR (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 1 over-capture interrupt flag
   --  (CC1OF) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC2OVR (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 2 over-capture interrupt flag
   --  (CC2OF) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC3OVR (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 3 over-capture interrupt flag
   --  (CC3OF) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CC4OVR (Instance : Instance_Type)
      return Boolean;
   --  Indicate whether the Capture/Compare 4 over-capture interrupt flag
   --  (CC4OF) is set
   --
   --  @param Instance TIM peripheral instance
   --  @return Flag status

   ---------------------------------------------------------------------------
   function Is_Enabled_Auto_Reload_Register_Preload (Instance : Instance_Type)
      return Boolean;
   --  Indicates whether auto-reload (ARR) preload is enabled.
   --
   --  @param Instance TIM peripheral instance
   --  @return Enable status

   ---------------------------------------------------------------------------
   function Is_Enabled_Capture_Compare_Channel (Instance : Instance_Type;
                                                Channel  : Channel_Type)
      return Boolean;
   --  Indicate whether the channel is enabled
   --
   --  Notes:
   --  - Differently from the reference implementation
   --    LL_TIM_CC_IsEnabledChannel, this procedure handles a single channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance
   --  @return Enable status

   ---------------------------------------------------------------------------
   function Is_Enabled_Counter (Instance : Instance_Type)
      return Boolean;
   --  Indicates whether the timer counter is enabled
   --
   --  @param Instance TIM peripheral instance
   --  @return Enable status

   ---------------------------------------------------------------------------
   function Is_Enabled_Update_Event (Instance : Instance_Type)
      return Boolean;
   --  Indicates whether update event generation is enabled
   --
   --  @param Instance TIM peripheral instance
   --  @return Enable status

   ---------------------------------------------------------------------------
   procedure Set_Auto_Reload (Instance    : Instance_Type;
                              Auto_Reload : Auto_Reload_Type);
   --  Set the auto-reload value
   --
   --  Notes:
   --  - The counter is blocked while the auto-reload value is zero.
   --
   --  @param Instance TIM peripheral instance
   --  @param Auto_Reload Auto-reload value

   ---------------------------------------------------------------------------
   procedure Set_Counter (Instance : Instance_Type;
                          Counter  : Counter_Type);
   --  Set the counter value
   --
   --  @param Instance TIM peripheral instance
   --  @param Counter Counter value

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
   --  @param Instance TIM peripheral instance
   --  @param Counter_Mode Counter mode

   ---------------------------------------------------------------------------
   procedure Set_Clock_Division (Instance       : Instance_Type;
                                 Clock_Division : Clock_Division_Type);
   --  Set the division ratio between the timer clock and the sampling clock
   --  used by the dead-time generators (when supported) and the digital
   --  filters.
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_CLOCK_DIVISION_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Clock_Division Clock division

   ---------------------------------------------------------------------------
   procedure Set_Clock_Source (Instance     : Instance_Type;
                               Clock_Source : Clock_Source_Type);
   --  Set the clock source of the counter clock
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_CLOCKSOURCE_ETRMODE1_INSTANCE and
   --    IS_TIM_CLOCKSOURCE_ETRMODE2_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Clock_Source Clock source

   ---------------------------------------------------------------------------
   procedure Set_DMA_Request_Trigger (Instance    : Instance_Type;
                                      DMA_Trigger : DMA_Trigger_Type);
   --  Set the trigger of the capture/compare DMA request
   --
   --  @param Instance TIM peripheral instance
   --  @param DMA_Trigger_Type DMA trigger type

   ---------------------------------------------------------------------------
   procedure Set_Encoder_Mode (Instance     : Instance_Type;
                               Encoder_Mode : Encoder_Mode_Type);
   --  Set the encoder interface mode
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --    IS_TIM_ENCODER_INTERFACE_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Encoder_Mode Encoder mode

   ---------------------------------------------------------------------------
   procedure Set_One_Pulse_Mode (Instance       : Instance_Type;
                                 One_Pulse_Mode : One_Pulse_Mode_Type);
   --  Set one pulse mode
   --
   --  @param Instance TIM peripheral instance
   --  @param Update_Source Update event source

   ---------------------------------------------------------------------------
   procedure Set_Output_Compare_Compare (Instance : Instance_Type;
                                         Channel  : Channel_Type;
                                         Compare  : Compare_Type);
   --  Set compare value for output channel
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --     IS_TIM_CC1_INSTANCE, IS_TIM_CC2_INSTANCE, IS_TIM_CC3_INSTANCE,
   --     IS_TIM_CC4_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance
   --  @param Compare Compare value

   ---------------------------------------------------------------------------
   procedure Set_Output_Compare_Mode (Instance : Instance_Type;
                                      Channel  : Channel_Type;
                                      Mode     : Output_Compare_Mode_Type);
   --  Define the behaviour of the output reference signal OCxREF from which
   --  OCx and OCxN (when relevant) are derived.
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance
   --  @param Mode Mode

   ---------------------------------------------------------------------------
   procedure Set_Output_Compare_Polarity (Instance : Instance_Type;
                                          Channel  : Channel_Type;
                                          Polarity : Polarity_Type);
   --  Set the polarity of an output channel
   --
   --  @param Instance TIM peripheral instance
   --  @param Channel TIM channel instance
   --  @param Polarity Polarity

   ---------------------------------------------------------------------------
   procedure Set_Prescaler (Instance  : Instance_Type;
                            Prescaler : Prescaler_Type);
   --  Set the prescaler value
   --
   --  Notes:
   --  - The prescaler can be changed on the fly as this control register is
   --    buffered. The new prescaler ratio is taken into account at the next
   --    update event.
   --
   --  @param Instance TIM peripheral instance
   --  @param Prescaler Prescaler value

   ---------------------------------------------------------------------------
   procedure Set_Slave_Mode (Instance   : Instance_Type;
                             Slave_Mode : Slave_Mode_Type);
   --  Set the synchronization mode of a slave timer
   --
   --  TODO:
   --  - Implement precondition contract equivalent to
   --     IS_TIM_SLAVE_INSTANCE
   --
   --  @param Instance TIM peripheral instance
   --  @param Slave_Mode Slave mode

   ---------------------------------------------------------------------------
   procedure Set_Trigger_Input (Instance      : Instance_Type;
                                Trigger_Input : Trigger_Input_Type);
   --  Set the trigger input to be used to synchronize the counter
   --
   --  @param Instance TIM peripheral instance
   --  @param Trigger_Input Trigger input

   ---------------------------------------------------------------------------
   procedure Set_Trigger_Output (Instance       : Instance_Type;
                                 Trigger_Output : Trigger_Output_Type);
   --  Set the trigger output used for timer synchronization
   --
   --  @param Instance TIM peripheral instance
   --  @param Trigger_Output Trigger output

   ---------------------------------------------------------------------------
   procedure Set_Update_Source (Instance      : Instance_Type;
                                Update_Source : Update_Source_Type);
   --  Set update event source
   --
   --  @param Instance TIM peripheral instance
   --  @param Update_Source Update event source

end LL.TIM;