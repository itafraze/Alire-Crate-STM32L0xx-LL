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
--    2024.10 E. Zarfati
--       - First version
--
------------------------------------------------------------------------------

with System;
   use all type System.Address;
with CMSIS.Device.DMA.Instances;
   use all type CMSIS.Device.DMA.Instances.Instance_Type;
   use all type CMSIS.Device.DMA.Instances.Channel_Type;

package LL.DMA is
   --  Direct Memory Access (DMA) low-level driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_dma.h

   subtype Instance_Type is
      CMSIS.Device.DMA.Instances.Instance_Type;
   --  Export DMA instances

   subtype Channel_Type is
      CMSIS.Device.DMA.Instances.Channel_Type;
   --  Export DMA channels

   type Direction_Type is
      (PERIPHERAL_TO_MEMORY, MEMORY_TO_PERIPHERAL, MEMORY_TO_MEMORY)
      with Default_Value => PERIPHERAL_TO_MEMORY;
   --  Transfer Direction
   --
   --  @enum PERIPHERAL_TO_MEMORY Peripheral to memory direction
   --  @enum MEMORY_TO_PERIPHERAL Memory to peripheral direction
   --  @enum MEMORY_TO_MEMORY Memory to memory direction

   type Mode_Type is
      (NORMAL, CIRCULAR)
      with Default_Value => NORMAL;
   --  Transfer mode
   --
   --  @enum NORMAL Normal Mode
   --  @enum CIRCULAR Circular Mode

   type Increment_Type is
      new Boolean
      with Default_Value => False;
   --  The peripheral or memory address register may be incremented or not

   type Data_Alignment_Type is
      (BYTE, HALF_WORD, WORD)
      with Default_Value => WORD;
   --  Peripheral data alignment
   --
   --   @enum BYTE Peripheral data alignment : Byte
   --   @enum HALF_WORD Peripheral data alignment : HalfWord
   --   @enum WORD Peripheral data alignment : Word

   type Priority_Type is
      (LOW, MEDIUM, HIGH, VERY_HIGH)
      with Default_Value => LOW;
   --  Transfer Priority level
   --
   --  @enum LOW Priority level : Low
   --  @enum MEDIUM Priority level : Medium
   --  @enum HIGH Priority level : High
   --  @enum VERY_HIGH Priority level : Very_High

   type Configuration_Type is
      record
         Direction : Direction_Type;
         Mode : Mode_Type;
         Peripheral_Increment : Increment_Type;
         Memory_Increment : Increment_Type;
         Peripheral_Data_Alignment : Data_Alignment_Type;
         Memory_Data_Alignment : Data_Alignment_Type;
         Priority : Priority_Type;
      end record;
   --  Type of channel configuration parameters
   --
   --  @field Direction Specifies the data transfer direction
   --  @field Mode Specifies the operation mode
   --  @field Peripheral_Increment Specifies whether the address is
   --    incremented
   --  @field Memory_Increment Specifies whether the address is incremented

   subtype Transfer_Length_Type is
      Positive range 1 .. 2**15;
   --  Number of tranfers

   subtype Address_Type is
      System.Address;
   --  Type of memory address

   type Request_Type is
      (REQUEST_0, REQUEST_1, REQUEST_2, REQUEST_3, REQUEST_4, REQUEST_5,
         REQUEST_6, REQUEST_7, REQUEST_8, REQUEST_9, REQUEST_10, REQUEST_11,
         REQUEST_12, REQUEST_13, REQUEST_14, REQUEST_15)
      with Default_Value => REQUEST_0;
   --  Transfer peripheral request
   --
   --  Notes:
   --  - Not all requests are available for all channels and devices
   --
   --  @enum REQUEST_0 DMA peripheral request 0
   --  @enum REQUEST_1 DMA peripheral request 1
   --  @enum REQUEST_2 DMA peripheral request 2
   --  @enum REQUEST_3 DMA peripheral request 3
   --  @enum REQUEST_4 DMA peripheral request 4
   --  @enum REQUEST_5 DMA peripheral request 5
   --  @enum REQUEST_6 DMA peripheral request 6
   --  @enum REQUEST_7 DMA peripheral request 7
   --  @enum REQUEST_8 DMA peripheral request 8
   --  @enum REQUEST_9 DMA peripheral request 9
   --  @enum REQUEST_10 DMA peripheral request 10
   --  @enum REQUEST_11 DMA peripheral request 11
   --  @enum REQUEST_12 DMA peripheral request 12
   --  @enum REQUEST_13 DMA peripheral request 13
   --  @enum REQUEST_14 DMA peripheral request 14
   --  @enum REQUEST_15 DMA peripheral request 15

   ---------------------------------------------------------------------------
   procedure Enable_Channel (Instance : Instance_Type;
                             Channel  : Channel_Type);
   --  Enable DMA channel
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   procedure Disable_Channel (Instance : Instance_Type;
                              Channel  : Channel_Type);
   --  Disable DMA channel
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   function Is_Enabled_Channel (Instance : Instance_Type;
                                Channel  : Channel_Type)
      return Boolean;
   --  Check if DMA channel is enabled or disabled.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return True if enabled

   ---------------------------------------------------------------------------
   procedure Configure_Transfer (Instance      : Instance_Type;
                                 Channel       : Channel_Type;
                                 Configuration : Configuration_Type);
   --  Configure all parameters link to DMA transfer
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Configuration of the transfer

   ---------------------------------------------------------------------------
   procedure Set_Data_Transfer_Direction (Instance  : Instance_Type;
                                          Channel   : Channel_Type;
                                          Direction : Direction_Type);
   --  Set Data transfer direction (read from peripheral or from memory).
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Direction of the tranfer

   ---------------------------------------------------------------------------
   function Get_Data_Transfer_Direction (Instance : Instance_Type;
                                         Channel  : Channel_Type)
      return Direction_Type;
   --  Get Data transfer direction (read from peripheral or from memory).
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Direction of the tranfer

   ---------------------------------------------------------------------------
   procedure Set_Mode (Instance : Instance_Type;
                       Channel  : Channel_Type;
                       Mode     : Mode_Type);
   --  Set DMA mode circular or normal.
   --
   --  The circular buffer mode cannot be used if the memory-to-memory data
   --  transfer is configured on the selected Channel.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Mode of the tranfer

   ---------------------------------------------------------------------------
   function Get_Mode (Instance : Instance_Type;
                      Channel  : Channel_Type)
      return Mode_Type;
   --  Get DMA mode circular or normal.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Mode of the tranfer

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Increment_Mode (Instance  : Instance_Type;
                                            Channel   : Channel_Type;
                                            Increment : Increment_Type);
   --  Set Peripheral increment mode.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Increment mode of the peripheral data

   ---------------------------------------------------------------------------
   function Get_Peripheral_Increment_Mode (Instance : Instance_Type;
                                           Channel  : Channel_Type)
      return Increment_Type;
   --  Get Peripheral increment mode.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Increment mode of the peripheral data

   ---------------------------------------------------------------------------
   procedure Set_Memory_Increment_Mode (Instance  : Instance_Type;
                                        Channel   : Channel_Type;
                                        Increment : Increment_Type);
   --  Set Memory increment mode.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Increment mode of the Memory data

   ---------------------------------------------------------------------------
   function Get_Memory_Increment_Mode (Instance : Instance_Type;
                                       Channel  : Channel_Type)
      return Increment_Type;
   --  Get Memory increment mode.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Increment mode of the Memory data

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Size (Instance  : Instance_Type;
                                  Channel   : Channel_Type;
                                  Data_Size : Data_Alignment_Type);
   --  Set Peripheral size.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Data_Size Peripheral or Memory-to-memory source data size

   ---------------------------------------------------------------------------
   function Get_Peripheral_Size (Instance  : Instance_Type;
                                 Channel   : Channel_Type)
      return Data_Alignment_Type;
   --  Get Peripheral size.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Peripheral or Memory-to-memory source data size

   ---------------------------------------------------------------------------
   procedure Set_Memory_Size (Instance  : Instance_Type;
                              Channel   : Channel_Type;
                              Data_Size : Data_Alignment_Type);
   --  Set Memory size.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Data_Size Memory or Memory-to-memory destination data size

   ---------------------------------------------------------------------------
   function Get_Memory_Size (Instance  : Instance_Type;
                             Channel   : Channel_Type)
      return Data_Alignment_Type;
   --  Get Memory size.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Memory or Memory-to-memory destination data size

   ---------------------------------------------------------------------------
   procedure Set_Channel_Priority_Level (Instance : Instance_Type;
                                         Channel  : Channel_Type;
                                         Priority : Priority_Type);
   --  Set Channel priority level.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Priority of the transfer

   ---------------------------------------------------------------------------
   function Get_Channel_Priority_Level (Instance : Instance_Type;
                                        Channel  : Channel_Type)
      return Priority_Type;
   --  Get Channel priority level.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Priority of the transfer

   ---------------------------------------------------------------------------
   procedure Set_Data_Length (Instance       : Instance_Type;
                              Channel        : Channel_Type;
                              Number_Of_Data : Transfer_Length_Type);
   --  Set Number of data to transfer
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Number_Of_Data transferred

   ---------------------------------------------------------------------------
   function Get_Data_Length (Instance       : Instance_Type;
                             Channel        : Channel_Type)
      return Transfer_Length_Type;
   --  Get Number of data to transfer
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Number of data transferred

   ---------------------------------------------------------------------------
   procedure Config_Addresses (Instance    : Instance_Type;
                               Channel     : Channel_Type;
                               Source      : Address_Type;
                               Destination : Address_Type;
                               Direction   : Direction_Type);
   --  Configure the Source and Destination addresses
   --
   --  This API must not be called when the DMA channel is enabled.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Source address
   --  @param Destination address
   --  @param Direction of the transfer

   ---------------------------------------------------------------------------
   procedure Set_Memory_Address (Instance : Instance_Type;
                                 Channel  : Channel_Type;
                                 Memory   : Address_Type);
   --  Set the Memory address
   --
   --  Notes:
   --  - Interface used for direction PERIPHERAL_TO_MEMORY or
   --    MEMORY_TO_PERIPHERAL only.
   --  - This API must not be called when the DMA channel is enabled
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Memory address

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Address (Instance   : Instance_Type;
                                     Channel    : Channel_Type;
                                     Peripheral : Address_Type);
   --  Set the Peripheral address
   --
   --  Notes:
   --  - Interface used for direction PERIPHERAL_TO_MEMORY or
   --    MEMORY_TO_PERIPHERAL only.
   --  - This API must not be called when the DMA channel is enabled
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Peripheral address

   ---------------------------------------------------------------------------
   function Get_Memory_Address (Instance : Instance_Type;
                                Channel  : Channel_Type)
      return Address_Type;
   --  Get the Memory address
   --
   --  Notes:
   --  - Interface used for direction PERIPHERAL_TO_MEMORY or
   --    MEMORY_TO_PERIPHERAL only.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Memory address

   ---------------------------------------------------------------------------
   function Get_Peripheral_Address (Instance : Instance_Type;
                                    Channel  : Channel_Type)
      return Address_Type;
   --  Get the Peripheral address
   --
   --  Notes:
   --  - Interface used for direction PERIPHERAL_TO_MEMORY or
   --    MEMORY_TO_PERIPHERAL only.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Peripheral address

   ---------------------------------------------------------------------------
   procedure Set_Memory_To_Memory_Source_Address (Instance : Instance_Type;
                                                  Channel  : Channel_Type;
                                                  Memory   : Address_Type);
   --  Set the Memory to Memory Source address
   --
   --  Notes:
   --  - Interface used for direction MEMORY_TO_MEMORY only
   --  - This API must not be called when the DMA channel is enabled
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Memory address

   ---------------------------------------------------------------------------
   procedure Set_Memory_To_Memory_Destination_Address (
      Instance : Instance_Type;
      Channel  : Channel_Type;
      Memory   : Address_Type);
   --  Set the Memory to Memory Destination address
   --
   --  Notes:
   --  - Interface used for direction MEMORY_TO_MEMORY only
   --  - This API must not be called when the DMA channel is enabled
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Memory address

   ---------------------------------------------------------------------------
   function Get_Memory_To_Memory_Source_Address (Instance : Instance_Type;
                                                 Channel  : Channel_Type)
      return Address_Type;
   --  Get the Memory to Memory Source address
   --
   --  Notes:
   --  - Interface used for direction MEMORY_TO_MEMORY only
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Memory address

   ---------------------------------------------------------------------------
   function Get_Memory_To_Memory_Destination_Address (Instance : Instance_Type;
                                                      Channel  : Channel_Type)
      return Address_Type;
   --  Get the Memory to Memory Destination address
   --
   --  Notes:
   --  - Interface used for direction MEMORY_TO_MEMORY only
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Memory address

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Request (Instance   : Instance_Type;
                                     Channel    : Channel_Type;
                                     Peripheral : Request_Type);
   --  Set DMA request for DMA instance on Channel x
   --
   --  Notes:
   --  - Please refer to Reference Manual to get the available mapping of
   --    Request value link to Channel Selection.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @param Peripheral request

   ---------------------------------------------------------------------------
   function Get_Peripheral_Request (Instance   : Instance_Type;
                                    Channel    : Channel_Type)
      return Request_Type;
   --  Get DMA request for DMA instance on Channel x
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel
   --  @return Peripheral request

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI1 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 1 global interrupt flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI2 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 2 global interrupt flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI3 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 3 global interrupt flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI4 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 4 global interrupt flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI5 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 5 global interrupt flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI6 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 6 global interrupt flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI7 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 7 global interrupt flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC1 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 1 transfer complete flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC2 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 2 transfer complete flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC3 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 3 transfer complete flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC4 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 4 transfer complete flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC5 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 5 transfer complete flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC6 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 6 transfer complete flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC7 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 7 transfer complete flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT1 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 1 half transfer flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT2 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 2 half transfer flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT3 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 3 half transfer flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT4 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 4 half transfer flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT5 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 5 half transfer flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT6 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 6 half transfer flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT7 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 7 half transfer flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE1 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 1 transfer error flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE2 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 2 transfer error flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE3 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 3 transfer error flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE4 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 4 transfer error flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE5 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 5 transfer error flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE6 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 6 transfer error flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE7 (Instance : Instance_Type)
      return Boolean;
   --  Get Channel 7 transfer error flag.
   --
   --  @param Instance DMAx Instance
   --  @return State of flag

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI1 (Instance : Instance_Type);
   --  Clear Channel 1 global interrupt flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI2 (Instance : Instance_Type);
   --  Clear Channel 2 global interrupt flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI3 (Instance : Instance_Type);
   --  Clear Channel 3 global interrupt flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI4 (Instance : Instance_Type);
   --  Clear Channel 4 global interrupt flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI5 (Instance : Instance_Type);
   --  Clear Channel 5 global interrupt flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI6 (Instance : Instance_Type);
   --  Clear Channel 6 global interrupt flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI7 (Instance : Instance_Type);
   --  Clear Channel 7 global interrupt flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC1 (Instance : Instance_Type);
   --  Clear Channel 1 transfer complete flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC2 (Instance : Instance_Type);
   --  Clear Channel 2 transfer complete flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC3 (Instance : Instance_Type);
   --  Clear Channel 3 transfer complete flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC4 (Instance : Instance_Type);
   --  Clear Channel 4 transfer complete flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC5 (Instance : Instance_Type);
   --  Clear Channel 5 transfer complete flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC6 (Instance : Instance_Type);
   --  Clear Channel 6 transfer complete flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC7 (Instance : Instance_Type);
   --  Clear Channel 7 transfer complete flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT1 (Instance : Instance_Type);
   --  Clear Channel 1 half transfer flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT2 (Instance : Instance_Type);
   --  Clear Channel 2 half transfer flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT3 (Instance : Instance_Type);
   --  Clear Channel 3 half transfer flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT4 (Instance : Instance_Type);
   --  Clear Channel 4 half transfer flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT5 (Instance : Instance_Type);
   --  Clear Channel 5 half transfer flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT6 (Instance : Instance_Type);
   --  Clear Channel 6 half transfer flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT7 (Instance : Instance_Type);
   --  Clear Channel 7 half transfer flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE1 (Instance : Instance_Type);
   --  Clear Channel 1 transfer error flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE2 (Instance : Instance_Type);
   --  Clear Channel 2 transfer error flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE3 (Instance : Instance_Type);
   --  Clear Channel 3 transfer error flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE4 (Instance : Instance_Type);
   --  Clear Channel 4 transfer error flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE5 (Instance : Instance_Type);
   --  Clear Channel 5 transfer error flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE6 (Instance : Instance_Type);
   --  Clear Channel 6 transfer error flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE7 (Instance : Instance_Type);
   --  Clear Channel 7 transfer error flag.
   --
   --  @param Instance DMAx Instance

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_TC (Instance : Instance_Type;
                                  Channel  : Channel_Type);
   --  Enable Transfer complete interrupt
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_HT (Instance : Instance_Type;
                                  Channel  : Channel_Type);
   --  Enable Half transfer interrupt.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_TE (Instance : Instance_Type;
                                  Channel  : Channel_Type);
   --  Enable Transfer error interrupt.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_TC (Instance : Instance_Type;
                                   Channel  : Channel_Type);
   --  Disable Transfer complete interrupt
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_HT (Instance : Instance_Type;
                                   Channel  : Channel_Type);
   --  Disable Half transfer interrupt.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_TE (Instance : Instance_Type;
                                   Channel  : Channel_Type);
   --  Disable Transfer error interrupt.
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_TC (Instance : Instance_Type;
                                    Channel  : Channel_Type)
      return Boolean;
   --  Check if Transfer complete interrupt is enabled
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_HT (Instance : Instance_Type;
                                     Channel  : Channel_Type)
      return Boolean;
   --  Check if Half transfer interrupt is enabled
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_TE (Instance : Instance_Type;
                                     Channel  : Channel_Type)
      return Boolean;
   --  Check if Transfer error interrupt is enabled
   --
   --  @param Instance DMAx Instance
   --  @param Channel Instance channel

end LL.DMA;