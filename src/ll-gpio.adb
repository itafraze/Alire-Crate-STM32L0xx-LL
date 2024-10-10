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
--    2024.10 E. Zarfati
--       - Complete implementation
--
------------------------------------------------------------------------------

with CMSIS.Device;
   use CMSIS.Device;
with CMSIS.Device.GPIO;
   use CMSIS.Device.GPIO;
with CMSIS.Device.GPIO.Instances;
   use CMSIS.Device.GPIO.Instances;

package body LL.GPIO is
   --  General Purpose Input/Output (GPIO) low-layer driver body
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_gpio.h
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_gpio.c

   ---------------------------------------------------------------------------
   procedure Set_Pin_Mode (Instance : Instance_Type;
                           Pin      : Pin_Type;
                           Mode     : Mode_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      GPIO.MODER.Arr (Pin_Type'Pos (Pin)) := Mode_Type'Pos (Mode);

   end Set_Pin_Mode;

   ---------------------------------------------------------------------------
   function Get_Pin_Mode (Instance : Instance_Type;
                          Pin      : Pin_Type)
      return Mode_Type is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Mode_Type'Val (GPIO.MODER.Arr (Pin_Type'Pos (Pin)));

   end Get_Pin_Mode;

   ---------------------------------------------------------------------------
   procedure Set_Pin_Output_Type (Instance : Instance_Type;
                                  Pin      : Pin_Type;
                                  Output   : Output_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      GPIO.OTYPER.OT.Arr (Pin_Type'Pos (Pin)) := Output_Type'Pos (Output);

   end Set_Pin_Output_Type;

   ---------------------------------------------------------------------------
   function Get_Pin_Output_Type (Instance : Instance_Type;
                                 Pin      : Pin_Type)
      return Output_Type is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Output_Type'Val (GPIO.OTYPER.OT.Arr (Pin_Type'Pos (Pin)));

   end Get_Pin_Output_Type;

   ---------------------------------------------------------------------------
   procedure Set_Pin_Speed (Instance : Instance_Type;
                            Pin      : Pin_Type;
                            Speed    : Speed_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      GPIO.OSPEEDR.Arr (Pin_Type'Pos (Pin)) := Speed_Type'Pos (Speed);

   end Set_Pin_Speed;

   ---------------------------------------------------------------------------
   function Get_Pin_Speed (Instance : Instance_Type;
                           Pin      : Pin_Type)
      return Speed_Type is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Speed_Type'Val (GPIO.OSPEEDR.Arr (Pin_Type'Pos (Pin)));

   end Get_Pin_Speed;

   ---------------------------------------------------------------------------
   procedure Set_Pin_Pull (Instance : Instance_Type;
                           Pin      : Pin_Type;
                           Pull     : Pull_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      GPIO.PUPDR.Arr (Pin_Type'Pos (Pin)) := Pull_Type'Pos (Pull);

   end Set_Pin_Pull;

   ---------------------------------------------------------------------------
   function Get_Pin_Pull (Instance : Instance_Type;
                          Pin      : Pin_Type)
      return Pull_Type is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Pull_Type'Val (GPIO.PUPDR.Arr (Pin_Type'Pos (Pin)));

   end Get_Pin_Pull;

   ---------------------------------------------------------------------------
   procedure Set_Alternate_Function (Instance  : Instance_Type;
                                     Pin       : Pin_Type;
                                     Alternate : Alternate_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      case All_Pin_Type (Pin) is
         when PIN_0 .. PIN_7 => GPIO.AFRL.Arr (Pin_Type'Pos (Pin)) :=
            AFRL_AFSEL_Element (Alternate_Type'Pos (Alternate));
         when PIN_8 .. PIN_15 => GPIO.AFRH.Arr (Pin_Type'Pos (Pin)) :=
            AFRH_AFSEL_Element (Alternate_Type'Pos (Alternate));
      end case;

   end Set_Alternate_Function;

   ---------------------------------------------------------------------------
   function Get_Alternate_Function (Instance  : Instance_Type;
                                    Pin       : Pin_Type)
      return Alternate_Type is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Alternate_Type'Val (case All_Pin_Type (Pin) is
         when PIN_0 .. PIN_7 => GPIO.AFRL.Arr (Pin_Type'Pos (Pin)),
         when PIN_8 .. PIN_15 => GPIO.AFRH.Arr (Pin_Type'Pos (Pin)));

   end Get_Alternate_Function;


   ---------------------------------------------------------------------------
   procedure Lock_Pin (Instance : Instance_Type;
                       Pin      : Pin_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
      LCKR_Value : LCKR_Register := (
         LCKK => LCKR_LCKK_Field (2#1#),
         LCK => (As_Array => False, Val => 2#0#),
         others => 2#0#);
      --
   begin

      LCKR_Value.LCK.Arr (Pin_Type'Pos (Pin)) := LCKR_LCK_Element (2#1#);

      GPIO.LCKR := LCKR_Value;
      GPIO.LCKR := (LCKR_Value with delta LCKK => LCKR_LCKK_Field (2#0#));
      GPIO.LCKR := LCKR_Value;

      --  Read LCKK register. This read is mandatory to complete key lock
      --  sequence
      LCKR_Value := GPIO.LCKR;

   end Lock_Pin;

   ---------------------------------------------------------------------------
   function Is_Pin_Locked (Instance : Instance_Type;
                           Pin      : Pin_Type)
      return Boolean is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (GPIO.LCKR.LCK.Arr (Pin_Type'Pos (Pin)));

   end Is_Pin_Locked;

   ---------------------------------------------------------------------------
   function Is_Any_Pin_Locked (Instance : Instance_Type)
      return Boolean is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
      Locked : Boolean;
      --
   begin

      for Pin in Pin_Type
      loop
         Locked := Boolean'Val (GPIO.LCKR.LCK.Arr (Pin_Type'Pos (Pin)));
         exit when Locked;
      end loop;

      return Locked;

   end Is_Any_Pin_Locked;

   ---------------------------------------------------------------------------
   function Read_Input_Port (Instance : Instance_Type)
      return Port_Value_Type is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Port_Value_Type (GPIO.IDR.ID.Val);

   end Read_Input_Port;

   ---------------------------------------------------------------------------
   function Is_Input_Pin_Set (Instance : Instance_Type;
                              Pin      : Pin_Type)
      return Boolean is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (GPIO.IDR.ID.Arr (Pin_Type'Pos (Pin)));

   end Is_Input_Pin_Set;

   ---------------------------------------------------------------------------
   procedure Write_Output_Port (Instance  : Instance_Type;
                                Port_Value : Port_Value_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      GPIO.ODR.OD.Val := UInt16 (Port_Value);

   end Write_Output_Port;

   ---------------------------------------------------------------------------
   function Read_Output_Port (Instance : Instance_Type)
      return Port_Value_Type is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Port_Value_Type (GPIO.ODR.OD.Val);

   end Read_Output_Port;

   ---------------------------------------------------------------------------
   function Is_Output_Pin_Set (Instance : Instance_Type;
                               Pin      : Pin_Type)
      return Boolean is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      return Boolean'Val (GPIO.ODR.OD.Arr (Pin_Type'Pos (Pin)));

   end Is_Output_Pin_Set;

   ---------------------------------------------------------------------------
   procedure Set_Output_Pin (Instance : Instance_Type;
                             Pin      : Pin_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      GPIO.BSRR.BS.Arr (Pin_Type'Pos (Pin)) := BSRR_BS_Element (2#1#);

   end Set_Output_Pin;

   ---------------------------------------------------------------------------
   procedure Reset_Output_Pin (Instance : Instance_Type;
                               Pin      : Pin_Type) is
   --
      GPIO renames
         GPIOx (All_Instance_Type (Instance));
      --
   begin

      GPIO.BSRR.BR.Arr (Pin_Type'Pos (Pin)) := BSRR_BR_Element (2#1#);

   end Reset_Output_Pin;

   ---------------------------------------------------------------------------
   procedure Toggle_Pin (Instance : Instance_Type;
                         Pin      : Pin_Type) is
   begin

      if Is_Output_Pin_Set (Instance, Pin)
      then
         Reset_Output_Pin (Instance, Pin);
      else
         Set_Output_Pin (Instance, Pin);
      end if;

   end Toggle_Pin;

end LL.GPIO;
