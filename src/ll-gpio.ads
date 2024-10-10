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

with CMSIS.Device.GPIO.Instances;
   use all type CMSIS.Device.GPIO.Instances.Instance_Type;

package LL.GPIO is
   --  General Purpose Input/Output (GPIO) low-layer driver
   --
   --  Analog-to-Digital Converter (ADC) peripheral initialization functions
   --  and APIs
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_gpio.h

   subtype Instance_Type is
      CMSIS.Device.GPIO.Instances.Instance_Type;
   --

   subtype Pin_Type is
      CMSIS.Device.GPIO.Instances.Pin_Type;
   --

   type Mode_Type is
      (INPUT, OUTPUT, ALTERNATE, ANALOG)
      with Default_Value => ANALOG;
   --  Mode
   --
   --  @enum INPUT Select input mode
   --  @enum OUTPUT Select output mode
   --  @enum ALTERNATE Select alternate function mode
   --  @enum ANALOG Select analog mode

   type Output_Type is
      (PUSHPULL, OPENDRAIN);
   --  Output Type
   --
   --  @enum PUSHPULL Select push-pull as output type
   --  @enum OPENDRAIN Select open-drain as output type

   type Speed_Type is
      (LOW, MEDIUM, HIGH, VERY_HIGH);
   --  Output Speed
   --
   --  @enum LOW Select I/O low output speed
   --  @enum MEDIUM Select I/O medium output speed
   --  @enum HIGH Select I/O fast output speed
   --  @enum VERY_HIGH Select I/O high output speed

   type Pull_Type is
      (NO, UP, DOWN);
   --  Pull Up Pull Down
   --  @enum NO
   --  @enum UP
   --  @enum DOWN

   type Alternate_Type is
      (AF_0, AF_1, AF_2, AF_3, AF_4, AF_5, AF_6, AF_7);
   --  Alternate Function
   --  @enum AF_0 Select alternate function 0
   --  @enum AF_1 Select alternate function 1
   --  @enum AF_2 Select alternate function 2
   --  @enum AF_3 Select alternate function 3
   --  @enum AF_4 Select alternate function 4
   --  @enum AF_5 Select alternate function 5
   --  @enum AF_6 Select alternate function 6
   --  @enum AF_7 Select alternate function 7

   subtype Port_Value_Type is
      Natural;
   --

   ---------------------------------------------------------------------------
   procedure Set_Pin_Mode (Instance : Instance_Type;
                           Pin      : Pin_Type;
                           Mode     : Mode_Type);
   --  Configure gpio mode for a dedicated pin on dedicated port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @param Mode

   ---------------------------------------------------------------------------
   function Get_Pin_Mode (Instance : Instance_Type;
                          Pin      : Pin_Type)
      return Mode_Type;
   --  Return gpio mode for a dedicated pin on dedicated port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Mode

   ---------------------------------------------------------------------------
   procedure Set_Pin_Output_Type (Instance : Instance_Type;
                                  Pin      : Pin_Type;
                                  Output   : Output_Type);
   --  Configure gpio output type for several pins on dedicated port
   --
   --  Notes:
   --  - Output type as to be set when gpio pin is in output or alternate
   --    modes.
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @param Output

   ---------------------------------------------------------------------------
   function Get_Pin_Output_Type (Instance : Instance_Type;
                                 Pin      : Pin_Type)
      return Output_Type;
   --  Return gpio output type for several pins on dedicated port
   --
   --  Notes:
   --  - Output type as to be set when gpio pin is in output or alternate
   --    modes.
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Output

   ---------------------------------------------------------------------------
   procedure Set_Pin_Speed (Instance : Instance_Type;
                            Pin      : Pin_Type;
                            Speed    : Speed_Type);
   --  Configure gpio speed for a dedicated pin on dedicated port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @param Speed

   ---------------------------------------------------------------------------
   function Get_Pin_Speed (Instance : Instance_Type;
                           Pin      : Pin_Type)
      return Speed_Type;
   --  Return gpio speed for a dedicated pin on dedicated port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Speed

   ---------------------------------------------------------------------------
   procedure Set_Pin_Pull (Instance : Instance_Type;
                           Pin      : Pin_Type;
                           Pull     : Pull_Type);
   --  Configure gpio pull-up or pull-down for a dedicated pin on a dedicated
   --  port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @param Pull

   ---------------------------------------------------------------------------
   function Get_Pin_Pull (Instance : Instance_Type;
                          Pin      : Pin_Type)
      return Pull_Type;
   --  Return gpio pull-up or pull-down for a dedicated pin on a dedicated port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Pull

   ---------------------------------------------------------------------------
   procedure Set_Alternate_Function (Instance  : Instance_Type;
                                     Pin       : Pin_Type;
                                     Alternate : Alternate_Type);
   --  Configure gpio alternate function of a dedicated pin
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @param Alternate

   ---------------------------------------------------------------------------
   function Get_Alternate_Function (Instance : Instance_Type;
                                    Pin      : Pin_Type)
      return Alternate_Type;
   --  Return gpio alternate function of a dedicated pin
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Alternate

   ---------------------------------------------------------------------------
   procedure Lock_Pin (Instance : Instance_Type;
                       Pin      : Pin_Type);
   --  Lock configuration of several pins for a dedicated port
   --
   --  Notes:
   --  - When the lock sequence has been applied on a port bit, the value of
   --    this port bit can no longer be modified until the next reset
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin

   ---------------------------------------------------------------------------
   function Is_Pin_Locked (Instance : Instance_Type;
                           Pin      : Pin_Type)
      return Boolean;
   --  Return if the pin passed as parameter, of a dedicated port, is locked
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Locked status

   ---------------------------------------------------------------------------
   function Is_Any_Pin_Locked (Instance : Instance_Type)
      return Boolean;
   --  Return if any pin passed as parameter, of a dedicated port, is locked
   --
   --  @param Instance GPIO Port
   --  @return Locked status

   ---------------------------------------------------------------------------
   function Read_Input_Port (Instance : Instance_Type)
      return Port_Value_Type;
   --  Return full input data register value for a dedicated port
   --
   --  @param Instance GPIO Port
   --  @return Port value

   ---------------------------------------------------------------------------
   function Is_Input_Pin_Set (Instance : Instance_Type;
                              Pin      : Pin_Type)
      return Boolean;
   --  Return if input data level for pin of dedicated port is high or low
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Pin status

   ---------------------------------------------------------------------------
   procedure Write_Output_Port (Instance   : Instance_Type;
                                Port_Value : Port_Value_Type);
   --  Write output data register for the port
   --
   --  @param Instance GPIO Port
   --  @param Port_Value

   ---------------------------------------------------------------------------
   function Read_Output_Port (Instance : Instance_Type)
      return Port_Value_Type;
   --  Return Return full output data register value for a dedicated port
   --
   --  @param Instance GPIO Port
   --  @return Port value

   ---------------------------------------------------------------------------
   function Is_Output_Pin_Set (Instance : Instance_Type;
                               Pin      : Pin_Type)
      return Boolean;
   --  Return if input data level for pin of dedicated port is high or low
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin
   --  @return Pin status

   ---------------------------------------------------------------------------
   procedure Set_Output_Pin (Instance  : Instance_Type;
                             Pin       : Pin_Type);
   --  Set pin to high level on dedicated gpio port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin

   ---------------------------------------------------------------------------
   procedure Reset_Output_Pin (Instance  : Instance_Type;
                               Pin       : Pin_Type);
   --  Set pin to low level on dedicated gpio port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin

   ---------------------------------------------------------------------------
   procedure Toggle_Pin (Instance  : Instance_Type;
                         Pin       : Pin_Type);
   --  Toggle data value for pin of dedicated port
   --
   --  @param Instance GPIO Port
   --  @param Pin Dedicated port's pin

end LL.GPIO;
