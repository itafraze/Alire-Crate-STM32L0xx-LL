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

with CMSIS.Device.LPTIM.Instances;
   use all type CMSIS.Device.LPTIM.Instances.Instance_Type;

package LL.LPTIM is
   --  Low-Power Timer (LPTIM) low-layer driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_lptim.h


   subtype Instance_Type is
      CMSIS.Device.LPTIM.Instances.Instance_Type;
   --

   type Operating_Mode_Type is
      (CONTINUOUS, ONESHOT)
      with Default_Value => CONTINUOUS;
   --
   --  @enum CONTINUOUS starts in continuous mode
   --  @enum ONESHOT Timer starts in single mode

   type Update_Mode_Type is
      (IMMEDIATE, ENDOFPERIOD)
      with Default_Value => IMMEDIATE;
   --
   --  @enum IMMEDIATE Preload is disabled: registers are updated after each
   --    APB bus write access
   --  @enum ENDOFPERIOD preload is enabled: registers are updated at the
   --    end of the current LPTIM period

   type Counter_Mode_Type is
      (INTERNAL, EXTERNAL)
      with Default_Value => INTERNAL;
   --
   --  @enum INTERNAL The counter is incremented following each internal clock
   --    pulse
   --  @enum EXTERNAL The counter is incremented following each valid clock
   --    pulse on the LPTIM external Input1

   type Waveform_Type is
      (PWM, SETONCE)
      with Default_Value => PWM;
   --
   --  @enum PWM LPTIM  generates either a PWM waveform or a One pulse
   --    waveform depending on chosen operating mode CONTINUOUS or ONESHOT
   --  @enum SETONCE LPTIM  generates a Set Once waveform

   type Output_Polarity_Type is
      (REGULAR, INVERSE)
      with Default_Value => REGULAR;
   --
   --  @enum REGULAR The LPTIM output reflects the compare results between
   --    LPTIMx_ARR and LPTIMx_CMP registers
   --  @enum INVERSE The LPTIM output reflects the inverse of the compare
   --    results between LPTIMx_ARR and LPTIMx_CMP registers

   type Prescaler_Type is
      (DIV1, DIV2, DIV4, DIV8, DIV16, DIV32, DIV64, DIV128)
      with Default_Value => DIV1;
   --
   --  @enum DIV1
   --  @enum DIV2
   --  @enum DIV4
   --  @enum DIV8
   --  @enum DIV16
   --  @enum DIV32
   --  @enum DIV64
   --  @enum DIV128

   type Source_Type is
      (GPIO, RTCALARMA, RTCALARMB, RTCTAMP1, RTCTAMP2, RTCTAMP3, COMP1, COMP2)
      with Default_Value => GPIO;
   --
   --  @enum GPIO TIMx_ETR input
   --  @enum RTCALARMA RTC Alarm A
   --  @enum RTCALARMB RTC Alarm B
   --  @enum RTCTAMP1 RTC Tamper 1
   --  @enum RTCTAMP2 RTC Tamper 2
   --  @enum RTCTAMP3 RTC Tamper 3
   --  @enum COMP1 COMP1 output
   --  @enum COMP2 COMP2 output

   type Filter_Type is
      (NONE, F2, F4, F8)
      with Default_Value => NONE;
   --
   --  @enum NONE Any trigger active level change is considered as a valid
   --    trigger
   --  @enum F2 Trigger active level change must be stable for at least 2
   --    clock periods before it is considered as valid trigger
   --  @enum F4 Trigger active level change must be stable for at least 4
   --    clock periods before it is considered as valid trigger
   --  @enum F8 Trigger active level change must be stable for at least 8
   --    clock periods before it is considered as valid trigger

   type Trigger_Polarity_Type is
      (RISING, FALLING, RISING_FALLING)
      with Default_Value => RISING;
   --
   --  @enum RISING LPTIM counter starts when a rising edge is detected
   --  @enum FALLING LPTIM counter starts when a falling edge is detected
   --  @enum RISING_FALLING LPTIM counter starts when a rising or a falling
   --    edge is detected

   type Clock_Source_Type is
      (INTERNAL, EXTERNAL)
      with Default_Value => INTERNAL;
   --
   --  @enum INTERNAL LPTIM is clocked by internal clock source (APB clock or
   --    any of the embedded oscillators)
   --  @enum EXTERNAL LPTIM is clocked by an external clock source through
   --    the LPTIM external Input1

   type Clock_Filter_Type is
      (NONE, F2, F4, F8)
      with Default_Value => NONE;
   --
   --  @enum NONE Any external clock signal level change is considered as a
   --    valid transition
   --  @enum F2 External clock signal level change must be stable for at least
   --    2 clock periods before it is considered as valid transition
   --  @enum F4 External clock signal level change must be stable for at least
   --    4 clock periods before it is considered as valid transition
   --  @enum F8 External clock signal level change must be stable for at least
   --    8 clock periods before it is considered as valid transition

   type Clock_Polarity_Type is
      (RISING, FALLING, RISING_FALLING)
      with Default_Value => RISING;
   --
   --  @enum RISING The rising edge is the active edge used for counting
   --  @enum FALLING The falling edge is the active edge used for counting
   --  @enum RISING_FALLING Both edges are active edges

   type Auto_Reload_Value_Type is
      new Positive range 1 .. (2**16 - 1)
      with Default_Value => 1;
   --

   type Compare_Value_Type is
      new Natural range 0 .. (2**16 - 1)
      with Default_Value => 0;
   --

   ---------------------------------------------------------------------------
   procedure Enable (Instance : Instance_Type);
   --  Enable the LPTIM instance
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Start_Counter (Instance       : Instance_Type;
                            Operating_Mode : Operating_Mode_Type);
   --  Starts the LPTIM counter in the desired mode.
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is enabled
   --
   --  @param Instance Low-Power Timer instance
   --  @param Operating_Mode

   ---------------------------------------------------------------------------
   procedure Set_Update_Mode (Instance    : Instance_Type;
                              Update_Mode : Update_Mode_Type);
   --  Set the LPTIM registers update mode (enable/disable register preload)
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance
   --  @param Update_Mode

   ---------------------------------------------------------------------------
   procedure Set_Auto_Reload (Instance          : Instance_Type;
                              Auto_Reload_Value : Auto_Reload_Value_Type);
   --  Set the auto reload value
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is enabled
   --
   --  NOTE:
   --  - The auto reload value must be strictly greater than the compare value
   --  - After setting the value, wait for the ARROK flag to be set before
   --    writing to the same register again to avoid unpredictable results.
   --
   --  @param Instance Low-Power Timer instance
   --  @param Auto_Reload_Value

   ---------------------------------------------------------------------------
   procedure Set_Compare (Instance      : Instance_Type;
                          Compare_Value : Compare_Value_Type);
   --  Set the compare value
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is enabled
   --
   --  NOTE:
   --  - After setting the value, wait for the CMPOK flag to be set before
   --    writing to the same register again to avoid unpredictable results.
   --
   --  @param Instance Low-Power Timer instance
   --  @param Compare_Value

   ---------------------------------------------------------------------------
   procedure Set_Counter_Mode (Instance     : Instance_Type;
                               Counter_Mode : Counter_Mode_Type);
   --  Set the counter mode (selection of the LPTIM counter clock source).
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance
   --  @param Counter_Mode

   ---------------------------------------------------------------------------
   procedure Configure_Output (Instance : Instance_Type;
                               Waveform : Waveform_Type;
                               Polarity : Output_Polarity_Type);
   --  Configure the LPTIM instance output (LPTIMx_OUT)
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  NOTE:
   --  - The output polarity change takes effect immediately, even before the
   --    timer is enabled
   --
   --  @param Instance Low-Power Timer instance
   --  @param Waveform
   --  @param Polarity

   ---------------------------------------------------------------------------
   procedure Set_Waveform (Instance : Instance_Type;
                           Waveform : Waveform_Type);
   --  Set waveform shape
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance
   --  @param Waveform

   ---------------------------------------------------------------------------
   procedure Set_Polarity (Instance : Instance_Type;
                           Polarity : Output_Polarity_Type);
   --  Set output polarity
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  NOTE:
   --  - The output polarity change takes effect immediately, even before the
   --    timer is enable
   --
   --  @param Instance Low-Power Timer instance
   --  @param Polarity

   ---------------------------------------------------------------------------
   procedure Set_Prescaler (Instance  : Instance_Type;
                            Prescaler : Prescaler_Type);
   --  Set actual prescaler division ratio.
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --  - Add contract precondition to ensure no prescaling is applied when the
   --    LPTIM is configured to be clocked by an internal clock source and the
   --    LPTIM counter is configured to be updated by active edges detected on
   --    the LPTIM external Input1
   --
   --  @param Instance Low-Power Timer instance
   --  @param Prescaler

   ---------------------------------------------------------------------------
   procedure Enable_Timeout (Instance : Instance_Type);
   --  Enable the timeout function. A trigger event arriving when the timer is
   --  already started will reset and restart the counter
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Timeout (Instance : Instance_Type);
   --  Disable the timeout function. A trigger event arriving when the timer
   --  is already started will be ignored
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Software_Trigger (Instance : Instance_Type);
   --  Start the LPTIM counter
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Configure_Trigger (Instance : Instance_Type;
                                Source   : Source_Type;
                                Filter   : Filter_Type;
                                Polarity : Trigger_Polarity_Type);
   --  Configure the external trigger used as a trigger event for the LPTIM.
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance
   --  @param Source
   --  @param Filter
   --  @param Polarity

   ---------------------------------------------------------------------------
   procedure Set_Clock_Source (Instance     : Instance_Type;
                               Clock_Source : Clock_Source_Type);
   --  Set the source of the clock used by the LPTIM instance.
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  @param Instance Low-Power Timer instance
   --  @param Clock_Source

   ---------------------------------------------------------------------------
   procedure Configure_Clock (Instance : Instance_Type;
                              Filter   : Clock_Filter_Type;
                              Polarity : Clock_Polarity_Type);
   --  Configure the active edge or edges used by the counter when the LPTIM
   --  is clocked by an external clock source.
   --
   --  TODO:
   --  - Add contract precondition to ensure LPTIM instance is disabled
   --
   --  NOTE:
   --  - When both external clock signal edges are considered active ones, the
   --    LPTIM must also be clocked by an internal clock source with a
   --    frequency equal to at least four times the external clock frequency.
   --  - An internal clock source must be present when a digital filter is
   --    required for external clock.
   --
   --  @param Instance Low-Power Timer instance
   --  @param Filter
   --  @param Polarity

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CMPM (Instance : Instance_Type);
   --  Clear the compare match flag (CMPMCF)
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CMPM (Instance : Instance_Type)
      return Boolean;
   --  Inform whether a compare match interrupt has occurred
   --
   --  @param Instance Low-Power Timer instance
   --  @return Flag active status

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ARRM (Instance : Instance_Type);
   --  Clear the autoreload match flag (ARRMCF)
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ARRM (Instance : Instance_Type)
      return Boolean;
   --  Inform whether a autoreload match interrupt has occurred
   --
   --  @param Instance Low-Power Timer instance
   --  @return Flag active status

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EXTTRIG (Instance : Instance_Type);
   --  Clear the external trigger valid edge flag(EXTTRIGCF).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EXTTRIG (Instance : Instance_Type)
      return Boolean;
   --  Inform whether a valid edge on the selected external trigger input has
   --  occurred
   --
   --  @param Instance Low-Power Timer instance
   --  @return Flag active status

   ---------------------------------------------------------------------------
   procedure Clear_Flag_CMPOK (Instance : Instance_Type);
   --  Clear the compare register update interrupt flag (CMPOKCF).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_CMPOK (Instance : Instance_Type)
      return Boolean;
   --  Informs whether the APB bus write operation to the LPTIMx_CMP register
   --  has been successfully completed. If so, a new one can be initiated.
   --
   --  @param Instance Low-Power Timer instance
   --  @return Flag active status

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ARROK (Instance : Instance_Type);
   --  Clear the autoreload register update interrupt flag (ARROKCF).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ARROK (Instance : Instance_Type)
      return Boolean;
   --  Informs whether the APB bus write operation to the LPTIMx_ARR register
   --  has been successfully completed. If so, a new one can be initiated.
   --
   --  @param Instance Low-Power Timer instance
   --  @return Flag active status

   ---------------------------------------------------------------------------
   procedure Clear_Flag_UP (Instance : Instance_Type);
   --  Clear the counter direction change to up interrupt flag (UPCF).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_UP (Instance : Instance_Type)
      return Boolean;
   --  Informs whether the counter direction has changed from down to up (when
   --  the LPTIM instance operates in encoder mode).
   --
   --  @param Instance Low-Power Timer instance
   --  @return Flag active status

   ---------------------------------------------------------------------------
   procedure Clear_Flag_DOWN (Instance : Instance_Type);
   --  Clear the counter direction change to down interrupt flag (DOWNCF).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_DOWN (Instance : Instance_Type)
      return Boolean;
   --  Informs whether the counter direction has changed from up to down (when
   --  the LPTIM instance operates in encoder mode).
   --
   --  @param Instance Low-Power Timer instance
   --  @return Flag active status

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CMPM (Instance : Instance_Type);
   --  Enable compare match interrupt (CMPMIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CMPM (Instance : Instance_Type);
   --  Disable compare match interrupt (CMPMIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_ARRM (Instance : Instance_Type);
   --  Enable autoreload match interrupt (ARRMIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_ARRM (Instance : Instance_Type);
   --  Disable autoreload match interrupt (ARRMIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_EXTTRIG (Instance : Instance_Type);
   --  Enable external trigger valid edge interrupt (EXTTRIGIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_EXTTRIG (Instance : Instance_Type);
   --  Disable external trigger valid edge interrupt (EXTTRIGIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_CMPOK (Instance : Instance_Type);
   --  Enable compare register write completed interrupt (CMPOKIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_CMPOK (Instance : Instance_Type);
   --  Disable compare register write completed interrupt (CMPOKIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_ARROK (Instance : Instance_Type);
   --  Enable autoreload register write completed interrupt (ARROKIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_ARROK (Instance : Instance_Type);
   --  Disable autoreload register write completed interrupt (ARROKIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_UP (Instance : Instance_Type);
   --  Enable direction change to up interrupt (UPIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_UP (Instance : Instance_Type);
   --  Disable direction change to up interrupt (UPIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_DOWN (Instance : Instance_Type);
   --  Enable direction change to down interrupt (DOWNIE).
   --
   --  @param Instance Low-Power Timer instance

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_DOWN (Instance : Instance_Type);
   --  Disable direction change to down interrupt (DOWNIE).
   --
   --  @param Instance Low-Power Timer instance

end LL.LPTIM;
