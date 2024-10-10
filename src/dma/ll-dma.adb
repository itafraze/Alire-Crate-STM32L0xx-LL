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

with Ada.Unchecked_Conversion;
with System.Storage_Elements;
with System.Address_To_Access_Conversions;

with CMSIS.Device;
   use CMSIS.Device;
with CMSIS.Device.DMA;
   use CMSIS.Device.DMA;
with CMSIS.Device.DMA.Instances;
   use CMSIS.Device.DMA.Instances;

package body LL.DMA is
   --  Direct Memory Access (DMA) low-level driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_dma.h
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_dma.c

   ---------------------------------------------------------------------------
   procedure Enable_Channel (Instance : Instance_Type;
                             Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.EN := CCR_EN_Field (2#1#);

   end Enable_Channel;

   ---------------------------------------------------------------------------
   procedure Disable_Channel (Instance : Instance_Type;
                              Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.EN := CCR_EN_Field (2#0#);

   end Disable_Channel;

   ---------------------------------------------------------------------------
   function Is_Enabled_Channel (Instance : Instance_Type;
                                Channel  : Channel_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Boolean'Val (CCRx.EN);

   end Is_Enabled_Channel;

   ---------------------------------------------------------------------------
   procedure Configure_Transfer (Instance      : Instance_Type;
                                 Channel       : Channel_Type;
                                 Configuration : Configuration_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.all := (@ with delta
         PL => CCR_PL_Field (
            Priority_Type'Pos (Configuration.Priority)),
         MSIZE => CCR_MSIZE_Field (
            Data_Alignment_Type'Pos (Configuration.Memory_Data_Alignment)),
         PSIZE => CCR_PSIZE_Field (
            Data_Alignment_Type'Pos (Configuration.Peripheral_Data_Alignment)),
         MINC => CCR_MINC_Field (
            Increment_Type'Pos (Configuration.Memory_Increment)),
         PINC => CCR_PINC_Field (
            Increment_Type'Pos (Configuration.Peripheral_Increment)),
         CIRC => CCR_CIRC_Field (
            Mode_Type'Pos (Configuration.Mode)),
         DIR => CCR_DIR_Field (case Configuration.Direction is
            when MEMORY_TO_PERIPHERAL => 2#1#,
            when others => 2#0#),
         MEM2MEM => CCR_MEM2MEM_Field (case Configuration.Direction is
            when MEMORY_TO_MEMORY => 2#1#,
            when others => 2#0#));

   end Configure_Transfer;

   ---------------------------------------------------------------------------
   procedure Set_Data_Transfer_Direction (Instance  : Instance_Type;
                                          Channel   : Channel_Type;
                                          Direction : Direction_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.all := (@ with delta
         DIR => CCR_DIR_Field (case Direction is
            when MEMORY_TO_PERIPHERAL => 2#1#,
            when others => 2#0#),
         MEM2MEM => CCR_MEM2MEM_Field (case Direction is
            when MEMORY_TO_MEMORY => 2#1#,
            when others => 2#0#));

   end Set_Data_Transfer_Direction;

   ---------------------------------------------------------------------------
   function Get_Data_Transfer_Direction (Instance : Instance_Type;
                                         Channel  : Channel_Type)
      return Direction_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
      Direction : Direction_Type;
      --
   begin

      if Boolean'Val (CCRx.DIR)
      then
         Direction := MEMORY_TO_PERIPHERAL;
      elsif Boolean'Val (CCRx.MEM2MEM)
      then
         Direction := MEMORY_TO_MEMORY;
      else
         Direction := PERIPHERAL_TO_MEMORY;
      end if;

      return Direction;

   end Get_Data_Transfer_Direction;

   ---------------------------------------------------------------------------
   procedure Set_Mode (Instance : Instance_Type;
                       Channel  : Channel_Type;
                       Mode     : Mode_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.CIRC := CCR_CIRC_Field (
         Mode_Type'Pos (Mode));

   end Set_Mode;

   ---------------------------------------------------------------------------
   function Get_Mode (Instance : Instance_Type;
                      Channel  : Channel_Type)
      return Mode_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Mode_Type'Val (CCRx.CIRC);

   end Get_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Increment_Mode (Instance  : Instance_Type;
                                            Channel   : Channel_Type;
                                            Increment : Increment_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.PINC := CCR_PINC_Field (
         Increment_Type'Pos (Increment));

   end Set_Peripheral_Increment_Mode;

   ---------------------------------------------------------------------------
   function Get_Peripheral_Increment_Mode (Instance  : Instance_Type;
                                           Channel   : Channel_Type)
      return Increment_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Increment_Type'Val (CCRx.PINC);

   end Get_Peripheral_Increment_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Memory_Increment_Mode (Instance  : Instance_Type;
                                        Channel   : Channel_Type;
                                        Increment : Increment_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.PINC := CCR_MINC_Field (
         Increment_Type'Pos (Increment));

   end Set_Memory_Increment_Mode;

   ---------------------------------------------------------------------------
   function Get_Memory_Increment_Mode (Instance  : Instance_Type;
                                       Channel   : Channel_Type)
      return Increment_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Increment_Type'Val (CCRx.MINC);

   end Get_Memory_Increment_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Size (Instance  : Instance_Type;
                                  Channel   : Channel_Type;
                                  Data_Size : Data_Alignment_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.PSIZE := CCR_PSIZE_Field (
         Data_Alignment_Type'Pos (Data_Size));

   end Set_Peripheral_Size;

   ---------------------------------------------------------------------------
   function Get_Peripheral_Size (Instance  : Instance_Type;
                                 Channel   : Channel_Type)
      return Data_Alignment_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Data_Alignment_Type'Val (CCRx.PSIZE);

   end Get_Peripheral_Size;

   ---------------------------------------------------------------------------
   procedure Set_Memory_Size (Instance  : Instance_Type;
                              Channel   : Channel_Type;
                              Data_Size : Data_Alignment_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.MSIZE := CCR_MSIZE_Field (
         Data_Alignment_Type'Pos (Data_Size));

   end Set_Memory_Size;

   ---------------------------------------------------------------------------
   function Get_Memory_Size (Instance  : Instance_Type;
                             Channel   : Channel_Type)
      return Data_Alignment_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Data_Alignment_Type'Val (CCRx.MSIZE);

   end Get_Memory_Size;

   ---------------------------------------------------------------------------
   procedure Set_Channel_Priority_Level (Instance : Instance_Type;
                                         Channel  : Channel_Type;
                                         Priority : Priority_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.PL := CCR_PL_Field (
         Priority_Type'Pos (Priority));

   end Set_Channel_Priority_Level;

   ---------------------------------------------------------------------------
   function Get_Channel_Priority_Level (Instance : Instance_Type;
                                        Channel  : Channel_Type)
      return Priority_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Priority_Type'Val (CCRx.PL);

   end Get_Channel_Priority_Level;

   ---------------------------------------------------------------------------
   procedure Set_Data_Length (Instance       : Instance_Type;
                              Channel        : Channel_Type;
                              Number_Of_Data : Transfer_Length_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CNDTRx : constant access CNDTR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CNDTR1'Access,
            when CHANNEL_2 => DMA.CNDTR2'Access,
            when CHANNEL_3 => DMA.CNDTR3'Access,
            when CHANNEL_4 => DMA.CNDTR4'Access,
            when CHANNEL_5 => DMA.CNDTR5'Access,
            when CHANNEL_6 => DMA.CNDTR6'Access,
            when CHANNEL_7 => DMA.CNDTR7'Access);
      --
   begin

      CNDTRx.NDT := CNDTR_NDT_Field (Number_Of_Data);

   end Set_Data_Length;


   ---------------------------------------------------------------------------
   function Get_Data_Length (Instance       : Instance_Type;
                             Channel        : Channel_Type)
      return Transfer_Length_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CNDTRx : constant access CNDTR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CNDTR1'Access,
            when CHANNEL_2 => DMA.CNDTR2'Access,
            when CHANNEL_3 => DMA.CNDTR3'Access,
            when CHANNEL_4 => DMA.CNDTR4'Access,
            when CHANNEL_5 => DMA.CNDTR5'Access,
            when CHANNEL_6 => DMA.CNDTR6'Access,
            when CHANNEL_7 => DMA.CNDTR7'Access);
      --
   begin

      return Transfer_Length_Type (CNDTRx.NDT);

   end Get_Data_Length;

   ---------------------------------------------------------------------------
   procedure Config_Addresses (Instance    : Instance_Type;
                               Channel     : Channel_Type;
                               Source      : Address_Type;
                               Destination : Address_Type;
                               Direction   : Direction_Type) is
   --
      type UInt32_Type is
         new UInt32
         with Volatile;
      --
      package Handles_Conversions is new
         System.Address_To_Access_Conversions (UInt32_Type);
      use Handles_Conversions;
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CMARx : constant access UInt32_Type := To_Pointer (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CMAR1'Address,
            when CHANNEL_2 => DMA.CMAR2'Address,
            when CHANNEL_3 => DMA.CMAR3'Address,
            when CHANNEL_4 => DMA.CMAR4'Address,
            when CHANNEL_5 => DMA.CMAR5'Address,
            when CHANNEL_6 => DMA.CMAR6'Address,
            when CHANNEL_7 => DMA.CMAR7'Address);
      --
      CPARx : constant access UInt32_Type := To_Pointer (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CPAR1'Address,
            when CHANNEL_2 => DMA.CPAR2'Address,
            when CHANNEL_3 => DMA.CPAR3'Address,
            when CHANNEL_4 => DMA.CPAR4'Address,
            when CHANNEL_5 => DMA.CPAR5'Address,
            when CHANNEL_6 => DMA.CPAR6'Address,
            when CHANNEL_7 => DMA.CPAR7'Address);
      --
   begin

      CMARx.all := UInt32_Type (
         System.Storage_Elements.To_Integer (case Direction is
            when MEMORY_TO_PERIPHERAL => Source,
            when others               => Destination));
      CPARx.all := UInt32_Type (
         System.Storage_Elements.To_Integer (case Direction is
            when MEMORY_TO_PERIPHERAL => Destination,
            when others               => Source));

   end Config_Addresses;


   ---------------------------------------------------------------------------
   procedure Set_Memory_Address (Instance : Instance_Type;
                                 Channel  : Channel_Type;
                                 Memory   : Address_Type) is
   --
      type UInt32_Type is
         new UInt32
         with Volatile;
      --
      package Handles_Conversions is new
         System.Address_To_Access_Conversions (UInt32_Type);
      use Handles_Conversions;
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CMARx : constant access UInt32_Type := To_Pointer (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CMAR1'Address,
            when CHANNEL_2 => DMA.CMAR2'Address,
            when CHANNEL_3 => DMA.CMAR3'Address,
            when CHANNEL_4 => DMA.CMAR4'Address,
            when CHANNEL_5 => DMA.CMAR5'Address,
            when CHANNEL_6 => DMA.CMAR6'Address,
            when CHANNEL_7 => DMA.CMAR7'Address);
      --
   begin

      CMARx.all := UInt32_Type (
         System.Storage_Elements.To_Integer (Memory));

   end Set_Memory_Address;

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Address (Instance   : Instance_Type;
                                     Channel    : Channel_Type;
                                     Peripheral : Address_Type) is
   --
      type UInt32_Type is
         new UInt32
         with Volatile;
      --
      package Handles_Conversions is new
         System.Address_To_Access_Conversions (UInt32_Type);
      use Handles_Conversions;
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CPARx : constant access UInt32_Type := To_Pointer (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CPAR1'Address,
            when CHANNEL_2 => DMA.CPAR2'Address,
            when CHANNEL_3 => DMA.CPAR3'Address,
            when CHANNEL_4 => DMA.CPAR4'Address,
            when CHANNEL_5 => DMA.CPAR5'Address,
            when CHANNEL_6 => DMA.CPAR6'Address,
            when CHANNEL_7 => DMA.CPAR7'Address);
      --
   begin

      CPARx.all := UInt32_Type (
         System.Storage_Elements.To_Integer (Peripheral));

   end Set_Peripheral_Address;

   ---------------------------------------------------------------------------
   function Get_Memory_Address (Instance : Instance_Type;
                                Channel  : Channel_Type)
      return Address_Type is
   --
      package Handles_Conversions is new
         System.Address_To_Access_Conversions (Address_Type);
      use Handles_Conversions;
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CMARx : constant access Address_Type := To_Pointer (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CMAR1'Address,
            when CHANNEL_2 => DMA.CMAR2'Address,
            when CHANNEL_3 => DMA.CMAR3'Address,
            when CHANNEL_4 => DMA.CMAR4'Address,
            when CHANNEL_5 => DMA.CMAR5'Address,
            when CHANNEL_6 => DMA.CMAR6'Address,
            when CHANNEL_7 => DMA.CMAR7'Address);
      --
   begin

      return CMARx.all;

   end Get_Memory_Address;

   ---------------------------------------------------------------------------
   function Get_Peripheral_Address (Instance : Instance_Type;
                                    Channel  : Channel_Type)
      return Address_Type is
   --
      package Handles_Conversions is new
         System.Address_To_Access_Conversions (Address_Type);
      use Handles_Conversions;
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CPARx : constant access Address_Type := To_Pointer (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CPAR1'Address,
            when CHANNEL_2 => DMA.CPAR2'Address,
            when CHANNEL_3 => DMA.CPAR3'Address,
            when CHANNEL_4 => DMA.CPAR4'Address,
            when CHANNEL_5 => DMA.CPAR5'Address,
            when CHANNEL_6 => DMA.CPAR6'Address,
            when CHANNEL_7 => DMA.CPAR7'Address);
      --
   begin

      return CPARx.all;

   end Get_Peripheral_Address;


   ---------------------------------------------------------------------------
   procedure Set_Memory_To_Memory_Source_Address (Instance : Instance_Type;
                                                  Channel  : Channel_Type;
                                                  Memory   : Address_Type)
      renames Set_Peripheral_Address;

   ---------------------------------------------------------------------------
   procedure Set_Memory_To_Memory_Destination_Address (
      Instance : Instance_Type;
      Channel  : Channel_Type;
      Memory   : Address_Type)
      renames Set_Memory_Address;

   ---------------------------------------------------------------------------
   function Get_Memory_To_Memory_Source_Address (Instance : Instance_Type;
                                                 Channel  : Channel_Type)
      return Address_Type
      renames Get_Peripheral_Address;

   ---------------------------------------------------------------------------
   function Get_Memory_To_Memory_Destination_Address (Instance : Instance_Type;
                                                      Channel  : Channel_Type)
      return Address_Type
      renames Get_Memory_Address;

   ---------------------------------------------------------------------------
   procedure Set_Peripheral_Request (Instance   : Instance_Type;
                                     Channel    : Channel_Type;
                                     Peripheral : Request_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      case All_Channel_Type (Channel) is
         when CHANNEL_1 =>
            DMA.CSELR.C1S := CSELR_C1S_Field (Request_Type'Pos (Peripheral));
         when CHANNEL_2 =>
            DMA.CSELR.C2S := CSELR_C2S_Field (Request_Type'Pos (Peripheral));
         when CHANNEL_3 =>
            DMA.CSELR.C3S := CSELR_C3S_Field (Request_Type'Pos (Peripheral));
         when CHANNEL_4 =>
            DMA.CSELR.C4S := CSELR_C4S_Field (Request_Type'Pos (Peripheral));
         when CHANNEL_5 =>
            DMA.CSELR.C5S := CSELR_C5S_Field (Request_Type'Pos (Peripheral));
         when CHANNEL_6 =>
            DMA.CSELR.C6S := CSELR_C6S_Field (Request_Type'Pos (Peripheral));
         when CHANNEL_7 =>
            DMA.CSELR.C7S := CSELR_C7S_Field (Request_Type'Pos (Peripheral));
      end case;

   end Set_Peripheral_Request;

   ---------------------------------------------------------------------------
   function Get_Peripheral_Request (Instance   : Instance_Type;
                                    Channel    : Channel_Type)
      return Request_Type is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Request_Type'Val (case All_Channel_Type (Channel) is
         when CHANNEL_1 => DMA.CSELR.C1S,
         when CHANNEL_2 => DMA.CSELR.C2S,
         when CHANNEL_3 => DMA.CSELR.C3S,
         when CHANNEL_4 => DMA.CSELR.C4S,
         when CHANNEL_5 => DMA.CSELR.C5S,
         when CHANNEL_6 => DMA.CSELR.C6S,
         when CHANNEL_7 => DMA.CSELR.C7S);

   end Get_Peripheral_Request;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI1 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.GIF1);

   end Is_Active_Flag_GI1;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI2 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.GIF2);

   end Is_Active_Flag_GI2;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI3 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.GIF3);

   end Is_Active_Flag_GI3;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI4 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.GIF4);

   end Is_Active_Flag_GI4;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI5 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.GIF5);

   end Is_Active_Flag_GI5;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI6 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.GIF6);
      end if;

      return Status;

   end Is_Active_Flag_GI6;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_GI7 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.GIF7);
      end if;

      return Status;

   end Is_Active_Flag_GI7;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC1 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TCIF1);

   end Is_Active_Flag_TC1;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC2 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TCIF2);

   end Is_Active_Flag_TC2;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC3 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TCIF3);

   end Is_Active_Flag_TC3;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC4 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TCIF4);

   end Is_Active_Flag_TC4;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC5 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TCIF5);

   end Is_Active_Flag_TC5;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC6 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.TCIF6);
      end if;

      return Status;

   end Is_Active_Flag_TC6;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TC7 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.TCIF7);
      end if;

      return Status;

   end Is_Active_Flag_TC7;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT1 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.HTIF1);

   end Is_Active_Flag_HT1;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT2 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.HTIF2);

   end Is_Active_Flag_HT2;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT3 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.HTIF3);

   end Is_Active_Flag_HT3;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT4 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.HTIF4);

   end Is_Active_Flag_HT4;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT5 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.HTIF5);

   end Is_Active_Flag_HT5;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT6 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.HTIF6);
      end if;

      return Status;

   end Is_Active_Flag_HT6;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HT7 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.HTIF7);
      end if;

      return Status;

   end Is_Active_Flag_HT7;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE1 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TEIF1);

   end Is_Active_Flag_TE1;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE2 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TEIF2);

   end Is_Active_Flag_TE2;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE3 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TEIF3);

   end Is_Active_Flag_TE3;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE4 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TEIF4);

   end Is_Active_Flag_TE4;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE5 (Instance : Instance_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (DMA.ISR.TEIF5);

   end Is_Active_Flag_TE5;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE6 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.TEIF6);
      end if;

      return Status;

   end Is_Active_Flag_TE6;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_TE7 (Instance : Instance_Type)
      return Boolean is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
      Status : Boolean := False;
      --  Returned value
   begin

      if Channel'Valid
      then
         Status := Boolean'Val (DMA.ISR.TEIF7);
      end if;

      return Status;

   end Is_Active_Flag_TE7;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI1 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CGIF1 := IFCR_CGIF1_Field (2#1#);

   end Clear_Flag_GI1;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI2 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CGIF2 := IFCR_CGIF2_Field (2#1#);

   end Clear_Flag_GI2;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI3 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CGIF3 := IFCR_CGIF3_Field (2#1#);

   end Clear_Flag_GI3;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI4 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CGIF4 := IFCR_CGIF4_Field (2#1#);

   end Clear_Flag_GI4;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI5 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CGIF5 := IFCR_CGIF5_Field (2#1#);

   end Clear_Flag_GI5;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI6 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CGIF6 := IFCR_CGIF6_Field (2#1#);
      end if;

   end Clear_Flag_GI6;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_GI7 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CGIF7 := IFCR_CGIF7_Field (2#1#);
      end if;

   end Clear_Flag_GI7;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC1 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTCIF1 := IFCR_CTCIF1_Field (2#1#);

   end Clear_Flag_TC1;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC2 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTCIF2 := IFCR_CTCIF2_Field (2#1#);

   end Clear_Flag_TC2;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC3 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTCIF3 := IFCR_CTCIF3_Field (2#1#);

   end Clear_Flag_TC3;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC4 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTCIF4 := IFCR_CTCIF4_Field (2#1#);

   end Clear_Flag_TC4;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC5 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTCIF5 := IFCR_CTCIF5_Field (2#1#);

   end Clear_Flag_TC5;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC6 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CTCIF6 := IFCR_CTCIF6_Field (2#1#);
      end if;

   end Clear_Flag_TC6;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TC7 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CTCIF7 := IFCR_CTCIF7_Field (2#1#);
      end if;

   end Clear_Flag_TC7;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT1 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CHTIF1 := IFCR_CHTIF1_Field (2#1#);

   end Clear_Flag_HT1;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT2 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CHTIF2 := IFCR_CHTIF2_Field (2#1#);

   end Clear_Flag_HT2;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT3 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CHTIF3 := IFCR_CHTIF3_Field (2#1#);

   end Clear_Flag_HT3;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT4 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CHTIF4 := IFCR_CHTIF4_Field (2#1#);

   end Clear_Flag_HT4;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT5 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CHTIF5 := IFCR_CHTIF5_Field (2#1#);

   end Clear_Flag_HT5;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT6 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CHTIF6 := IFCR_CHTIF6_Field (2#1#);
      end if;

   end Clear_Flag_HT6;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HT7 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CHTIF7 := IFCR_CHTIF7_Field (2#1#);
      end if;

   end Clear_Flag_HT7;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE1 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTEIF1 := IFCR_CTEIF1_Field (2#1#);

   end Clear_Flag_TE1;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE2 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTEIF2 := IFCR_CTEIF2_Field (2#1#);

   end Clear_Flag_TE2;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE3 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTEIF3 := IFCR_CTEIF3_Field (2#1#);

   end Clear_Flag_TE3;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE4 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTEIF4 := IFCR_CTEIF4_Field (2#1#);

   end Clear_Flag_TE4;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE5 (Instance : Instance_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
   begin

      DMA.IFCR.CTEIF5 := IFCR_CTEIF5_Field (2#1#);

   end Clear_Flag_TE5;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE6 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_6);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CTEIF6 := IFCR_CTEIF6_Field (2#1#);
      end if;

   end Clear_Flag_TE6;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_TE7 (Instance : Instance_Type) is
   --
      function All_Channel_To_Channel is
         new Ada.Unchecked_Conversion (Source => All_Channel_Type,
                                       Target => Channel_Type);
      --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      Channel : constant Channel_Type := All_Channel_To_Channel (CHANNEL_7);
      --
   begin

      if Channel'Valid
      then
         DMA.IFCR.CTEIF7 := IFCR_CTEIF7_Field (2#1#);
      end if;

   end Clear_Flag_TE7;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_TC (Instance : Instance_Type;
                                  Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.TCIE := CCR_TCIE_Field (2#1#);

   end Enable_Interrupt_TC;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_HT (Instance : Instance_Type;
                                  Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.HTIE := CCR_HTIE_Field (2#1#);

   end Enable_Interrupt_HT;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_TE (Instance : Instance_Type;
                                  Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.TEIE := CCR_TEIE_Field (2#1#);

   end Enable_Interrupt_TE;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_TC (Instance : Instance_Type;
                                   Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.TCIE := CCR_TCIE_Field (2#0#);

   end Disable_Interrupt_TC;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_HT (Instance : Instance_Type;
                                   Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.HTIE := CCR_HTIE_Field (2#0#);

   end Disable_Interrupt_HT;

   ---------------------------------------------------------------------------
   procedure Disable_Interrupt_TE (Instance : Instance_Type;
                                   Channel  : Channel_Type) is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      CCRx.TEIE := CCR_TEIE_Field (2#0#);

   end Disable_Interrupt_TE;


   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_TC (Instance : Instance_Type;
                                    Channel  : Channel_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Boolean'Val (CCRx.TCIE);

   end Is_Enabled_Interrupt_TC;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_HT (Instance : Instance_Type;
                                     Channel  : Channel_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Boolean'Val (CCRx.HTIE);

   end Is_Enabled_Interrupt_HT;

   ---------------------------------------------------------------------------
   function Is_Enabled_Interrupt_TE (Instance : Instance_Type;
                                     Channel  : Channel_Type)
      return Boolean is
   --
      DMA renames
         DMAx (All_Instance_Type (Instance));
      --
      CCRx : constant access CCR_Register := (
         case All_Channel_Type (Channel) is
            when CHANNEL_1 => DMA.CCR1'Access,
            when CHANNEL_2 => DMA.CCR2'Access,
            when CHANNEL_3 => DMA.CCR3'Access,
            when CHANNEL_4 => DMA.CCR4'Access,
            when CHANNEL_5 => DMA.CCR5'Access,
            when CHANNEL_6 => DMA.CCR6'Access,
            when CHANNEL_7 => DMA.CCR7'Access);
      --
   begin

      return Boolean'Val (CCRx.TEIE);

   end Is_Enabled_Interrupt_TE;

end LL.DMA;