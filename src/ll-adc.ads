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
   use all type CMSIS.Device.UInt32;
with CMSIS.Device.ADC.Instances;
   use all type CMSIS.Device.ADC.Instances.Instance_Type;
   use all type CMSIS.Device.ADC.Instances.Channel_Type;

package LL.ADC is
   --  Analog-to-Digital Converter (ADC) low-level driver
   --
   --  Analog-to-Digital Converter (ADC) peripheral initialization functions
   --  and APIs
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_adc.h

   subtype Instance_Type is
      CMSIS.Device.ADC.Instances.Instance_Type;
   --

   subtype Channel_Type is
      CMSIS.Device.ADC.Instances.Channel_Type;
   --

   type Analog_Watchdog_Monitored_Channels_Type is
      (DISABLE, SINGLE_CHANNEL, ALL_CHANNELS)
      with Default_Value => DISABLE;
   --  Analog watchdog - Monitored channels

   type Analog_Watchdog_Threshold_Type is
     (HIGH, LOW)
      with Default_Value => HIGH;
   --  Analog watchdog - Thresholds

   type Channel_Select_Type is
      array (Channel_Type)
      of Boolean
      with Pack, Default_Component_Value => False;
   --

   type Clock_Source_Type is
     (ASYNC, SYNC_PCLK_DIV2, SYNC_PCLK_DIV4, SYNC_PCLK_DIV1)
      with Default_Value => ASYNC;
   --  ADC instance - Clock source
   --
   --  @enum ASYNC asynchronous clock
   --  @enum SYNC_PCLK_DIV2 synchronous clock derived from AHB clock divided
   --    by 2
   --  @enum SYNC_PCLK_DIV4 synchronous clock derived from AHB clock divided
   --    by 4
   --  @enum SYNC_PCLK_DIV1 synchronous clock derived from AHB clock not
   --    divided

   type Common_Clock_Type is
      (DIV1, DIV2, DIV4, DIV6, DIV8, DIV10, DIV12, DIV16, DIV32, DIV64,
         DIV128, DIV256)
      with Default_Value => DIV1;
   --  ADC common - Clock source

   type Common_Frequency_Mode_Type is
      (HIGH, LOW)
      with Default_Value => HIGH;
   --  ADC common - Clock frequency mode

   type Common_Path_Internal_Type is
      (VREFINT, TEMPSENSOR, VLCD)
      with Default_Value => VREFINT;
   --  ADC common - Measurement path to internal channels

   type Common_Path_Internal_Select_Type is
      array (Common_Path_Internal_Type)
      of Boolean
      with Pack, Default_Component_Value => False;
   --  ADC common - Measurement path to internal channels selection

   type Data_Alignment_Type is
     (RIGHT, LEFT)
      with Default_Value => RIGHT;
   --
   --  @enum RIGHT Right aligned (alignment on data register LSB bit 0)
   --  @enum LEFT Left aligned (alignment on data register MSB bit 15)

   type Low_Power_Mode_Type is
     (MODE_NONE, AUTOWAIT, AUTOPOWEROFF, AUTOWAIT_AUTOPOWEROFF)
      with Default_Value => MODE_NONE;
   --
   --  @enum MODE_NONE
   --  @enum AUTOWAIT
   --  @enum AUTOPOWEROFF
   --  @enum AUTOWAIT_AUTOPOWEROFF

   type Oversampling_Scope_Type is
     (DISABLED, GROUP_REGULAR)
      with Default_Value => DISABLED;
   --  Oversampling - Oversampling scope

   type Oversampling_Discontinuous_Mode_Type is
     (CONTINUOUS, DISCONTINUOUS)
      with Default_Value => CONTINUOUS;
   --  Oversampling - Discontinuous mode

   type Oversampling_Ratio_Type is
     (RATIO_2, RATIO_4, RATIO_8, RATIO_16, RATIO_32, RATIO_64, RATIO_128,
         RATIO_256)
      with Default_Value => RATIO_2;
   --  Oversampling - Ratio

   type Oversampling_Shift_Type is
     (NONE, RIGHT_1, RIGHT_2, RIGHT_3, RIGHT_4, RIGHT_5, RIGHT_6, RIGHT_7,
         RIGHT_8)
      with Default_Value => NONE;
   --  Oversampling - Data shift

   type Resolution_Type is
     (RESOLUTION_12B, RESOLUTION_10B, RESOLUTION_8B, RESOLUTION_6B)
      with Default_Value => RESOLUTION_12B;
   --
   --  @enum RESOLUTION_12B 12 bits
   --  @enum RESOLUTION_10B 10 bits
   --  @enum RESOLUTION_8B 8 bits
   --  @enum RESOLUTION_6B 6 bits

   type Sampling_Time_Type is
      (CYCLES_1_5, CYCLES_3_5, CYCLES_7_5, CYCLES_12_5, CYCLES_19_5,
         CYCLES_39_5, CYCLES_79_5, CYCLES_160_5)
      with Default_Value => CYCLES_1_5;
   --  Channel - Sampling time

   type Init_Type is
      record
         Clock : Clock_Source_Type;
         Resolution : Resolution_Type;
         Data_Alignment : Data_Alignment_Type;
         Low_Power_Mode : Low_Power_Mode_Type;
      end record;
   --  Structure definition of some features of ADC instance
   --
   --  @field Clock Set ADC instance clock source and prescaler
   --  @field Resolution Set ADC resolution
   --  @field Data_Alignment Set ADC conversion data alignment
   --  @field Low_Power_Mode Set ADC low power mode

   type REG_Continuous_Mode_Type is
      (SINGLE, CONTINUOUS)
      with Default_Value => SINGLE;
   --  ADC group regular - Continuous mode

   type REG_DMA_Transfer_Type is
      (NONE, LIMIT, UNLIMIT)
      with Default_Value => NONE;
   --  ADC group regular - DMA transfer of ADC conversion data

   type REG_Overrun_Behaviour_Type is
      (PRESERVED, OVERWRITTEN)
      with Default_Value => PRESERVED;
   --   ADC group regular - Overrun behaviors on conversion data

   type REG_Sequencer_Scan_Direction_Type is
      (FORWARD, BACKWARD)
      with Default_Value => FORWARD;
   --  ADC group regular - Sequencer scan direction

   type REG_Sequencer_Discontinuous_Mode_Type is
      (DISABLE, EVERY_RANK)
      with Default_Value => DISABLE;
   --  ADC group regular - Sequencer discontinuous mode

   type REG_Trigger_Edge_Type is
      (RISING, FALLING, RISINGFALLING)
      with Default_Value => RISING;

   type REG_Trigger_Source_Type is
      (SOFTWARE, EXT_TIM6_TRGO, EXT_TIM21_CH2, EXT_TIM2_TRGO, EXT_TIM2_CH4,
         EXT_TIM22_TRGO, EXT_TIM21_TRGO, EXT_TIM2_CH3, EXT_TIM3_TRGO,
         EXT_EXTI_LINE11)
      with Default_Value => SOFTWARE;
   --  ADC group regular - Trigger source

   type REG_Init_Type is
      record
         Trigger_Source : REG_Trigger_Source_Type;
         Sequencer_Discontinuous : REG_Sequencer_Discontinuous_Mode_Type;
         Continuous_Mode : REG_Continuous_Mode_Type;
         DMA_Transfer : REG_DMA_Transfer_Type;
         Overrun : REG_Overrun_Behaviour_Type;
      end record;
   --  Structure definition of some features of ADC group regular
   --
   --  @field Trigger_Source Set ADC group regular conversion trigger source:
   --    internal (SW start) or from external peripheral (timer event,
   --    external interrupt line)
   --  @field Sequencer_Discontinuous Set ADC group regular sequencer
   --    discontinuous mode: sequence subdivided and scan conversions
   --    interrupted every selected number of ranks
   --  @field Continuous_Mode Set ADC continuous conversion mode on ADC
   --    group regular, whether ADC conversions are performed in single mode
   --    (one conversion per trigger) or in continuous mode (after the first
   --    trigger, following conversions launched successively automatically)
   --  @field DMA_Transfer Set ADC group regular conversion data transfer:
   --    no transfer or transfer by DMA, and DMA requests mode
   --  @field Overrun Set ADC group regular behaviors in case of overrun

   ---------------------------------------------------------------------------
   function Calculate_Vref_Analog_Voltage (Data       : Natural;
                                           Resolution : Resolution_Type)
      return Natural;
   --  Calculate analog reference voltage (Vref+) (unit: mVolt) from ADC
   --  conversion data of internal voltage reference VrefInt.
   --
   --  @param Data ADC conversion data (resolution 12 bits) of internal
   --    voltage reference VrefInt (unit: digital value).
   --  @param Resolution
   --  @return Analog reference voltage (unit: mV)

   ---------------------------------------------------------------------------
   function Calculate_Data_To_Voltage (Vref       : Natural;
                                       Data       : Natural;
                                       Resolution : Resolution_Type)
      return Natural;
   --  Calculate the voltage (unit: mVolt) corresponding to a ADC conversion
   --  data (unit: digital value).
   --
   --  @param Vref Analog reference voltage (unit: mV)
   --  @param Data ADC conversion data (resolution 12 bits) (unit: digital
   --    value).
   --  @param Resolution
   --  @return ADC conversion data equivalent voltage value (unit: mVolt)

   ---------------------------------------------------------------------------
   function Convert_Data_Resolution (Data              : Natural;
                                     Input_Resolution  : Resolution_Type;
                                     Output_Resolution : Resolution_Type)
      return Natural;
   --  Convert the ADC conversion data from a resolution to another
   --  resolution.
   --
   --  @param Data ADC conversion data to be converted
   --  @param Input_Resolution Resolution of to the data to be converted
   --  @param Output_Resolution Resolution of the data after conversion
   --  @return ADC conversion data to the requested resolution

   ---------------------------------------------------------------------------
   function Digital_Scale (Resolution : Resolution_Type)
      return Natural;
   --  Define the ADC conversion data full-scale digital value corresponding
   --  to the selected ADC resolution.
   --
   --  @param Resolution
   --  @return ADC conversion data equivalent to full scale

   ---------------------------------------------------------------------------
   procedure Clear_Flag_ADRDY (Instance : Instance_Type);
   --  Clear flag ADC ready
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOC (Instance : Instance_Type);
   --  Clear flag ADC group regular end of unitary conversion
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOS (Instance : Instance_Type);
   --  Clear flag ADC group regular end of sequence conversions
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_OVR (Instance : Instance_Type);
   --  Clear flag ADC group regular overrun
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOSMP (Instance : Instance_Type);
   --  Clear flag ADC group regular end of sampling phase
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_AWD1 (Instance : Instance_Type);
   --  Clear flag ADC analog watchdog 1 flag
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_EOCAL (Instance : Instance_Type);
   --  Clear flag ADC end of calibration
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Config_Analog_Watchdog_Thresholds (
      Instance       : Instance_Type;
      High_Threshold : Natural;
      Low_Threshold  : Natural);
   --  Set ADC analog watchdog thresholds value of both thresholds high and
   --  low
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param High_Threshold
   --  @param Low_Threshold

   ---------------------------------------------------------------------------
   procedure Config_Oversampling_Ratio_Shift (
      Instance : Instance_Type;
      Ratio    : Oversampling_Ratio_Type;
      Shift    : Oversampling_Shift_Type);
   --  Set ADC oversampling
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion ongoing on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Ratio
   --  @param Shift

   ---------------------------------------------------------------------------
   procedure Disable (Instance : Instance_Type);
   --  Disable the selected ADC instance
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_Internal_Regulator (Instance : Instance_Type);
   --  Disable ADC instance internal voltage regulator
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_IT_ADRDY (Instance : Instance_Type);
   --  Disable ADC ready
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOC (Instance : Instance_Type);
   --  Disable interruption ADC group regular end of unitary conversion
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOS (Instance : Instance_Type);
   --  Disable interruption ADC group regular end of sequence conversions
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_IT_OVR (Instance : Instance_Type);
   --  Disable ADC group regular interruption overrun
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOSMP (Instance : Instance_Type);
   --  Disable interruption ADC group regular end of sampling
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_IT_AWD1 (Instance : Instance_Type);
   --  Disable interruption ADC analog watchdog 1
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Disable_IT_EOCAL (Instance : Instance_Type);
   --  Disable interruption ADC end of calibration
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable (Instance : Instance_Type);
   --  Enable the selected ADC instance
   --
   --  Notes:
   --  - After ADC enable, a delay for ADC internal analog stabilization is
   --    required before performing a ADC conversion start
   --
   --  TODO:
   --  - Add contract precondition: ADC must be ADC disabled and ADC internal
   --    voltage regulator enabled
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_Internal_Regulator (Instance : Instance_Type);
   --  Enable ADC instance internal voltage regulator
   --
   --  Notes:
   --  - After ADC internal voltage regulator enable, a delay for ADC internal
   --    voltage regulator stabilization is required before performing a ADC
   --    calibration or ADC enable.
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_IT_ADRDY (Instance : Instance_Type);
   --  Enable ADC ready
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOC (Instance : Instance_Type);
   --  Enable interruption ADC group regular end of unitary conversion
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOS (Instance : Instance_Type);
   --  Enable interruption ADC group regular end of sequence conversions
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_IT_OVR (Instance : Instance_Type);
   --  Enable ADC group regular interruption overrun
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOSMP (Instance : Instance_Type);
   --  Enable interruption ADC group regular end of sampling
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_IT_AWD1 (Instance : Instance_Type);
   --  Enable interruption ADC analog watchdog 1
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure Enable_IT_EOCAL (Instance : Instance_Type);
   --  Enable interruption ADC end of calibration
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   function Is_Active_Flag_ADRDY (Instance : Instance_Type)
      return Boolean;
   --  Get flag ADC ready
   --
   --  @param Instance ADC peripheral instance
   --  @return State of the flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOC (Instance : Instance_Type)
      return Boolean;
   --  Get flag ADC group regular end of unitary conversion
   --
   --  @param Instance ADC peripheral instance
   --  @return State of the flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOS (Instance : Instance_Type)
      return Boolean;
   --  Get flag ADC group regular end of sequence conversions
   --
   --  @param Instance ADC peripheral instance
   --  @return State of the flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_OVR (Instance : Instance_Type)
      return Boolean;
   --  Get flag ADC group regular overrun
   --
   --  @param Instance ADC peripheral instance
   --  @return State of the flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOSMP (Instance : Instance_Type)
      return Boolean;
   --  Get flag ADC group regular end of sampling phase
   --
   --  @param Instance ADC peripheral instance
   --  @return State of the flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_AWD1 (Instance : Instance_Type)
      return Boolean;
   --  Get flag ADC analog watchdog 1 flag
   --
   --  @param Instance ADC peripheral instance
   --  @return State of the flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_EOCAL (Instance : Instance_Type)
      return Boolean;
   --  Get flag ADC end of calibration
   --
   --  @param Instance ADC peripheral instance
   --  @return State of the flag

   ---------------------------------------------------------------------------
   function Is_Calibration_Ongoing (Instance : Instance_Type)
      return Boolean;
   --  Get ADC calibration state
   --
   --  @param Instance ADC peripheral instance
   --  @return True if calibration in progress

   ---------------------------------------------------------------------------
   function Is_Disable_Ongoing (Instance : Instance_Type)
      return Boolean;
   --  Get the selected ADC instance disable state
   --
   --  @param Instance ADC peripheral instance
   --  @return True if ADC disable command ongoing

   ---------------------------------------------------------------------------
   function Is_Enabled (Instance : Instance_Type)
      return Boolean;
   --  Get the selected ADC instance enable state
   --
   --  @param Instance ADC peripheral instance
   --  @return False if ADC is disabled, True if ADC is enabled

   ---------------------------------------------------------------------------
   procedure Set_Analog_Watchdog_Monitored_Channels (
      Instance : Instance_Type;
      Group    : Analog_Watchdog_Monitored_Channels_Type;
      Channel  : Channel_Type := Channel_Type'First);
   --  Set ADC analog watchdog monitored channels: a single channel or all
   --  channels, on ADC group regular.
   --
   --  Implementation notes:
   --  - The original function LL_ADC_SetAnalogWDMonitChannels takes as input
   --    a single Channel Group parameter instead of separating Group and
   --    Channels to reuse Channel_Type
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Group
   --  @param Channel Use only if Group is SINGLE_CHANNEL

   ---------------------------------------------------------------------------
   procedure Set_Analog_Watchdog_Thresholds (
      Instance  : Instance_Type;
      Threshold : Analog_Watchdog_Threshold_Type;
      Value     : Natural);
   --  Set ADC analog watchdog threshold value of threshold high or low
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion ongoing on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Threshold Specify which threshold value to retrieve
   --  @param Value Specify which threshold value to retrieve

   ---------------------------------------------------------------------------
   procedure Set_Calibration_Factor (Instance           : Instance_Type;
                                     Calibration_Factor : Natural);
   --  Set ADC calibration factor in the mode single-ended or differential
   --  (for devices with differential mode available)
   --
   --  TODO:
   --  - Add contract precondition: ADC must be enabled, without calibration
   --    on going, without conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Calibration_Factor

   ---------------------------------------------------------------------------
   procedure Set_Common_Clock (Instance     : Instance_Type;
                               Common_Clock : Common_Clock_Type);
   --  Set parameter common to several ADC: Clock source and pre-scaler
   --
   --  Implementation notes:
   --  - The original function LL_ADC_SetCommonClock takes as input the ADC
   --    common instance instead of the ADC instance
   --
   --  TODO:
   --  - Add contract precondition: All ADC instances of the ADC common group
   --    must be disabled
   --
   --  @param Instance ADC peripheral instance
   --  @param Common_Clock ADC common clock asynchronous pre-scaler applied to
   --    each ADC instance

   ---------------------------------------------------------------------------
   procedure Set_Common_Frequency_Mode (
      Instance              : Instance_Type;
      Common_Frequency_Mode : Common_Frequency_Mode_Type);
   --  Set parameter common to several ADC: Clock low frequency mode
   --
   --  Implementation notes:
   --  - The original function LL_ADC_SetCommonClock takes as input the ADC
   --    common instance instead of the ADC instance
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Common_Frequency_Mode

   ---------------------------------------------------------------------------
   procedure Set_Common_Path_Internal_Channel (
      Instance      : Instance_Type;
      Path_Internal : Common_Path_Internal_Select_Type);
   --  Set parameter common to several ADC: measurement path to internal
   --  channels (VrefInt, temperature sensor, ...)
   --
   --  @param Instance ADC peripheral instance
   --  @param Path_Internal

   ---------------------------------------------------------------------------
   procedure Set_Clock (Instance     : Instance_Type;
                        Clock_Source : Clock_Source_Type);
   --  Set ADC instance clock source and pre-scaler
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled
   --
   --  @param Instance ADC peripheral instance
   --  @param Clock_Source

   ---------------------------------------------------------------------------
   procedure Set_Data_Alignment (Instance      : Instance_Type;
                                Data_Alignment : Data_Alignment_Type);
   --  Set ADC conversion data alignment
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Data_Alignment

   ---------------------------------------------------------------------------
   procedure Set_Low_Power_Mode (Instance       : Instance_Type;
                                 Low_Power_Mode : Low_Power_Mode_Type);
   --  Set ADC low power mode
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Low_Power_Mode

   ---------------------------------------------------------------------------
   procedure Set_Oversampling_Scope (
      Instance : Instance_Type;
      Scope    : Oversampling_Scope_Type);
   --  Set ADC oversampling scope
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion ongoing on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Oversampling_Scope

   ---------------------------------------------------------------------------
   procedure Set_Oversampling_Discontinuous (
      Instance : Instance_Type;
      Mode     : Oversampling_Discontinuous_Mode_Type);
   --  Set ADC oversampling discontinuous mode (triggered mode) on the
   --  selected ADC group.
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion ongoing on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Mode

   ---------------------------------------------------------------------------
   procedure Set_Resolution (Instance   : Instance_Type;
                             Resolution : Resolution_Type);
   --  Set ADC resolution
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Resolution

   ---------------------------------------------------------------------------
   procedure Set_Sampling_Time_Common_Channels (
      Instance      : Instance_Type;
      Sampling_Time : Sampling_Time_Type);
   --  Set sampling time common to a group of channels
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Sampling_Time

   ---------------------------------------------------------------------------
   procedure Start_Calibration (Instance : Instance_Type);
   --  Start ADC calibration in the mode single-ended or differential (for
   --  devices with differential mode available)
   --
   --  Notes:
   --  - A minimum number of ADC clock cycles are required between ADC end of
   --    calibration and ADC enable.
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled
   --  - Add contract precondition: ADC DMA transfer request should be
   --    disabled during calibration
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   function REG_Init (Instance : Instance_Type;
                      Init     : REG_Init_Type)
      return Status_Type;
   --  Initialize some features of ADC group regular
   --
   --  TODO:
   --  - Add contract preconditions:
   --    - ADC instance must be disabled
   --    - ADC group regular continuous mode and discontinuous mode can not be
   --      enabled simultaneously
   --
   --  @param Instance ADC peripheral instance
   --  @param Init Initialisation structure
   --  @return Operations success status

   ---------------------------------------------------------------------------
   function REG_Is_Conversion_Ongoing (Instance : Instance_Type)
      return Boolean;
   --  Get ADC group regular conversion state
   --
   --  @param Instance ADC peripheral instance
   --  @return True if conversion is ongoing on ADC group regular

   ---------------------------------------------------------------------------
   function REG_Is_Stop_Conversion_Ongoing (Instance : Instance_Type)
      return Boolean;
   --  Get ADC group regular command of conversion stop state
   --
   --  @param Instance ADC peripheral instance
   --  @return True if conversion stop is ongoing on ADC group regular

   ---------------------------------------------------------------------------
   function REG_Read_Conversion_Data_32 (Instance : Instance_Type)
      return CMSIS.Device.UInt32;
   --  Get ADC group regular conversion data, range fit for all ADC
   --  configurations: all ADC resolutions and all oversampling increased data
   --  width (for devices with feature oversampling)
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure REG_Set_Continuous_Mode (
      Instance   : Instance_Type;
      Continuous : REG_Continuous_Mode_Type);
   --  Set ADC continuous conversion mode on ADC group regular
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Continuous

   ---------------------------------------------------------------------------
   procedure REG_Set_DMA_Transfer (Instance     : Instance_Type;
                                   DMA_Transfer : REG_DMA_Transfer_Type);
   --  Set ADC group regular conversion data transfer: no transfer or transfer
   --  by DMA, and DMA requests mode.
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param DMA_Transfer

   ---------------------------------------------------------------------------
   procedure REG_Set_Overrun (Instance : Instance_Type;
                              Overrun  : REG_Overrun_Behaviour_Type);
   --  Set ADC group regular behaviors in case of overrun: data preserved or
   --  overwritten
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular
   --
   --  @param Instance ADC peripheral instance
   --  @param Overrun

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Channels (Instance : Instance_Type;
                                         Channels : Channel_Select_Type);
   --  Set ADC group regular sequence: channel on rank corresponding to
   --  channel number
   --
   --  Notes:
   --  - To measure internal channels (VrefInt, TempSensor, ...), measurement
   --    paths to internal channels must be enabled separately
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Channels

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Channels_Add (Instance : Instance_Type;
                                             Channels : Channel_Select_Type);
   --  Add channel to ADC group regular sequence: channel on rank
   --  corresponding to channel number.
   --
   --  Notes:
   --  - To measure internal channels (VrefInt, TempSensor, ...), measurement
   --    paths to internal channels must be enabled separately
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Channels

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Channels_Remove (
      Instance : Instance_Type;
      Channels : Channel_Select_Type);
   --  Remove channel to ADC group regular sequence: channel on rank
   --  corresponding to channel number
   --
   --  Notes:
   --  - To measure internal channels (VrefInt, TempSensor, ...), measurement
   --    paths to internal channels must be enabled separately
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Channels

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Discontinuous_Mode (
      Instance                : Instance_Type;
      Sequencer_Discontinuous : REG_Sequencer_Discontinuous_Mode_Type);
   --  Set ADC group regular sequencer discontinuous mode: sequence subdivided
   --  and scan conversions interrupted every selected number of ranks.
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Sequencer_Discontinuous

   ---------------------------------------------------------------------------
   procedure REG_Set_Sequencer_Scan_Direction (
      Instance       : Instance_Type;
      Scan_Direction : REG_Sequencer_Scan_Direction_Type);
   --  Set ADC group regular sequencer scan direction
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Scan_Direction

   ---------------------------------------------------------------------------
   procedure REG_Set_Trigger_Source (
      Instance       : Instance_Type;
      Trigger_Source : REG_Trigger_Source_Type);
   --  Set sampling time common to a group of channels
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Trigger_Source

   ---------------------------------------------------------------------------
   procedure REG_Set_Trigger_Edge (Instance     : Instance_Type;
                                   Trigger_Edge : REG_Trigger_Edge_Type);
   --  Set ADC group regular conversion trigger polarity
   --
   --  TODO:
   --  - Add contract precondition: ADC must be disabled or enabled without
   --    conversion on going on group regular.
   --
   --  @param Instance ADC peripheral instance
   --  @param Trigger_Edge

   ---------------------------------------------------------------------------
   procedure REG_Start_Conversion (Instance : Instance_Type);
   --  Start ADC group regular conversion
   --
   --  TODO:
   --  - Add contract precondition: ADC must be enabled without conversion on
   --    going on group regular, without conversion stop command on going on
   --    group regular, without ADC disable command on going.
   --
   --  @param Instance ADC peripheral instance

   ---------------------------------------------------------------------------
   procedure REG_Stop_Conversion (Instance : Instance_Type);
   --  Stop ADC group regular conversion.
   --
   --  TODO:
   --  - Add contract precondition: ADC must be enabled with conversion on
   --    going on group regular, without ADC disable command on going.
   --
   --  @param Instance ADC peripheral instance

end LL.ADC;
