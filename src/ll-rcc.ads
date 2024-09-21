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
--    2024.09 E. Zarfati
--       - First version
--
------------------------------------------------------------------------------

with CMSIS.Device.RCC;

package LL.RCC is
   --  Reset and Clock Control (RCC) low-level driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_rcc.h

   type HSE_Prescaler_Type is
      (DIV_2, DIV_4, DIV_8, DIV_16)
      with Default_Value => DIV_2;
   --  Type of the RTC HSE Prescaler
   --
   --  @enum DIV_2 HSE is divided by 2 for RTC clock
   --  @enum DIV_4 HSE is divided by 4 for RTC clock
   --  @enum DIV_8 HSE is divided by 8 for RTC clock
   --  @enum DIV_16 HSE is divided by 16 for RTC clock

   subtype HSI_Trim_Calibration_Type is
      CMSIS.Device.RCC.ICSCR_HSI16TRIM_Field;
   --  Type of high speed internal clock trimming value

   type LSE_Drive_Type is
      (LOW, MEDIUM_LOW, MEDIUM_HIGH, HIGH)
      with Default_Value => LOW;
   --  Type of the LSE oscillator drive capability
   --
   --  @enum LOW Xtal mode lower driving capability
   --  @enum MEDIUM_LOW Xtal mode medium low driving capability
   --  @enum MEDIUM_HIGH Xtal mode medium high driving capability
   --  @enum HIGH Xtal mode higher driving capability

   type MSI_Range_Type is
      (RANGE_0, RANGE_1, RANGE_2, RANGE_3, RANGE_4, RANGE_5, RANGE_6)
      with Default_Value => RANGE_0;
   --  Type of the MSI clock ranges
   --
   --  @enum RANGE_0 MSI = 65.536 KHz
   --  @enum RANGE_1 MSI = 131.072 KHz
   --  @enum RANGE_2 MSI = 262.144 KHz
   --  @enum RANGE_3 MSI = 524.288 KHz
   --  @enum RANGE_4 MSI = 1.048 MHz
   --  @enum RANGE_5 MSI = 2.097 MHz
   --  @enum RANGE_6 MSI = 4.194 MHz

   subtype MSI_Trim_Calibration_Type is
      CMSIS.Device.RCC.ICSCR_MSITRIM_Field;
   --  Type of multi-speed internal clock trimming values

   type System_Clock_Source_Type is
      (MSI, HSI, HSE, PLL)
      with Default_Value => MSI;
   --  Configure the system clock source
   --
   --  @enum MSI MSI selection as system clock
   --  @enum HSI HSI selection as system clock
   --  @enum HSE HSE selection as system clock
   --  @enum PLL PLL selection as system clock

   type AHB_Prescaler_Type is
      (DIV_1, DIV_2, DIV_4, DIV_8, DIV_16, DIV_64, DIV_128, DIV_256, DIV_512)
      with Default_Value => DIV_1;
   --  Type of the AHB prescaler
   --
   --  @enum DIV_1 SYSCLK not divided
   --  @enum DIV_2 SYSCLK divided by 2
   --  @enum DIV_4 SYSCLK divided by 4
   --  @enum DIV_8 SYSCLK divided by 8
   --  @enum DIV_16 SYSCLK divided by 16
   --  @enum DIV_64 SYSCLK divided by 64
   --  @enum DIV_128 SYSCLK divided by 128
   --  @enum DIV_256 SYSCLK divided by 256
   --  @enum DIV_512 SYSCLK divided by 512

   type APB1_Prescaler_Type is
      (DIV_1, DIV_2, DIV_4, DIV_8, DIV_16)
      with Default_Value => DIV_1;
   --  Type of the APB1 prescaler
   --
   --  @enum DIV_1 HCLK not divided
   --  @enum DIV_2 HCLK divided by 2
   --  @enum DIV_4 HCLK divided by 4
   --  @enum DIV_8 HCLK divided by 8
   --  @enum DIV_16 HCLK divided by 16

   type APB2_Prescaler_Type is
      (DIV_1, DIV_2, DIV_4, DIV_8, DIV_16)
      with Default_Value => DIV_1;
   --  Type of the APB2 prescaler
   --
   --  @enum DIV_1 HCLK not divided
   --  @enum DIV_2 HCLK divided by 2
   --  @enum DIV_4 HCLK divided by 4
   --  @enum DIV_8 HCLK divided by 8
   --  @enum DIV_16 HCLK divided by 16

   type Clock_After_Wake_Type is
      (MSI, HSI)
      with Default_Value => MSI;
   --  Wakeup from Stop and CSS backup clock selection
   --
   --  @enum MSI MSI selection after wake-up from STOP
   --  @enum HSI HSI selection after wake-up from STOP

   type MCO_Source_Type is
      (NOCLOCK, SYSCLK, HSI, MSI, HSE, PLLCLK, LSI, LSE, HSI48)
      with Default_Value => NOCLOCK;
   --  Type of the Microcontroller clock output source
   --
   --  @enum NOCLOCK MCO output disabled, no clock on MCO
   --  @enum SYSCLK SYSCLK selection as MCO source
   --  @enum HSI HSI selection as MCO source
   --  @enum MSI MSI selection as MCO source
   --  @enum HSE HSE selection as MCO source
   --  @enum PLLCLK PLLCLK selection as MCO source
   --  @enum LSI LSI selection as MCO source
   --  @enum LSE LSE selection as MCO source
   --  @enum HSI48 HSI48 selection as MCO source

   type MCO_Prescaler_Type is
      (DIV_1, DIV_2, DIV_4, DIV_8, DIV_16)
      with Default_Value => DIV_1;
   --  Type of the Microcontroller clock output prescaler
   --
   --  @enum DIV_1 MCO Clock divided by 1
   --  @enum DIV_2 MCO Clock divided by 2
   --  @enum DIV_4 MCO Clock divided by 4
   --  @enum DIV_8 MCO Clock divided by 8
   --  @enum DIV_16 MCO Clock divided by 16

   type USART1_Source_Type is
      (PCLK2, SYSCLK, HSI, LSE)
      with Default_Value => PCLK2;
   --  Type of the USARTx clock source
   --
   --  @enum PCLK2 PCLK2 selected as USART1 clock
   --  @enum SYSCLK SYSCLK selected as USART1 clock
   --  @enum HSI HSI selected as USART1 clock
   --  @enum LSE LSE selected as USART1 clock

   type USART2_Source_Type is
      (PCLK1, SYSCLK, HSI, LSE)
      with Default_Value => PCLK1;
   --  Type of the USARTx clock source
   --
   --  @enum PCLK1 PCLK1 selected as USART2 clock
   --  @enum SYSCLK SYSCLK selected as USART2 clock
   --  @enum HSI HSI selected as USART2 clock
   --  @enum LSE LSE selected as USART2 clock

   type LPUART1_Source_Type is
      (PCLK1, SYSCLK, HSI, LSE)
      with Default_Value => PCLK1;
   --  Type of the LPUART1 clock source
   --
   --  @enum PCLK1 PCLK1 selected as LPUART1 clock
   --  @enum SYSCLK SYSCLK selected as LPUART1 clock
   --  @enum HSI HSI selected as LPUART1 clock
   --  @enum LSE LSE selected as LPUART1 clock

   type I2C1_Source_Type is
      (PCLK1, SYSCLK, HSI)
      with Default_Value => PCLK1;
   --  Type of the I2C1 clock source
   --
   --  @enum PCLK1 PCLK1 selected as I2C1 clock
   --  @enum SYSCLK SYSCLK selected as I2C1 clock
   --  @enum HSI HSI selected as I2C1 clock

   type I2C3_Source_Type is
      (PCLK1, SYSCLK, HSI)
      with Default_Value => PCLK1;
   --  Type of the I2C3 clock source
   --
   --  @enum PCLK1 PCLK1 selected as I2C3 clock
   --  @enum SYSCLK SYSCLK selected as I2C3 clock
   --  @enum HSI HSI selected as I2C3 clock

   type LPTIM1_Source_Type is
      (PCLK1, LSI, HSI, LSE)
      with Default_Value => PCLK1;
   --  Type of the LPTIM1 clock source
   --
   --  @enum PCLK1 PCLK1 selected as LPTIM1 clock
   --  @enum LSI LSI selected as LPTIM1 clock
   --  @enum HSI HSI selected as LPTIM1 clock
   --  @enum LSE LSE selected as LPTIM1 clock

   type RNG_Source_Type is
      (PLL, HSI48)
      with Default_Value => PLL;
   --  Type of the RNG clock source
   --
   --  @enum PLL PLL selected as RNG clock
   --  @enum HSI48 HSI48 selected as RNG clock

   type USB_Source_Type is
      (PLL, HSI48)
      with Default_Value => PLL;
   --  Type of the USB clock source
   --
   --  @enum PLL PLL selected as USB clock
   --  @enum HSI48 HSI48 selected as USB clock

   type RTC_Source_Type is
      (NONE, LSE, LSI, HSE)
      with Default_Value => NONE;
   --  Type of the RTC clock source
   --
   --  @enum NONE No clock used as RTC clock
   --  @enum LSE LSE oscillator clock used as RTC clock
   --  @enum LSI LSI oscillator clock used as RTC clock
   --  @enum HSE HSE oscillator clock divided by a programmable prescaler

   ---------------------------------------------------------------------------
   procedure HSE_Enable_CSS is null
      with Inline;
   --  Enable the Clock Security System
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure HSE_Enable_Bypass
      with Inline;
   --  Enable HSE external oscillator (HSE Bypass)

   ---------------------------------------------------------------------------
   procedure HSE_Disable_Bypass
      with Inline;
   --  Disable HSE external oscillator (HSE Bypass)

   ---------------------------------------------------------------------------
   procedure HSE_Enable
      with Inline;
   --  Enable HSE crystal oscillator (HSE ON)

   ---------------------------------------------------------------------------
   procedure HSE_Disable
      with Inline;
   --  Disable HSE crystal oscillator (HSE ON)

   ---------------------------------------------------------------------------
   function HSE_Is_Ready
      return Boolean
      with Inline;
   --  Check if HSE oscillator ready

   ---------------------------------------------------------------------------
   procedure Set_RTC_HSE_Prescaler (HSE_Prescaler : HSE_Prescaler_Type);
   --  Configure the RTC prescaler (divider)

   ---------------------------------------------------------------------------
   function Get_RTC_HSE_Prescaler
      return HSE_Prescaler_Type;
   --  Get the RTC prescaler (divider)

   ---------------------------------------------------------------------------
   procedure HSI_Enable
      with Inline;
   --  Enable HSI oscillator

   ---------------------------------------------------------------------------
   procedure HSI_Disable
      with Inline;
   --  Disable HSI oscillator

   ---------------------------------------------------------------------------
   function HSI_Is_Ready
      return Boolean
      with Inline;
   --  Check if HSI oscillator ready

   ---------------------------------------------------------------------------
   procedure HSI_Enable_In_Stop_Mode
      with Inline;
   --  Enable HSI even in stop mode

   ---------------------------------------------------------------------------
   procedure HSI_Disable_In_Stop_Mode
      with Inline;
   --  Disable HSI in stop mode

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Divider
      with Inline;
   --  Enable HSI divider (it divides by 4)

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Divider
      with Inline;
   --  Disable HSI divider (it divides by 4)

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Output
      with Inline;
   --  Enable HSI output

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Output
      with Inline;
   --  Disable HSI output

   ---------------------------------------------------------------------------
   function HSI_Get_Calibration
      return Natural
      with Inline;
   --  Get HSI calibration value
   --
   --  Notes:
   --  - When HSITRIM is written, HSICAL is updated with the sum of HSITRIM and
   --    the factory trim value

   ---------------------------------------------------------------------------
   procedure HSI_Set_Calibration_Trimming (Value : HSI_Trim_Calibration_Type)
      with Inline;
   --  Set HSI calibration trimming
   --
   --  Notes:
   --  - User-programmable trimming value that is added to the HSICAL
   --  - Default value is 16, which, when added to the HSICAL value, should
   --    trim the HSI to 16 MHz +/- 1 %
   --
   --  TODO:
   --  - Replace HSI_Trim_Calibration_Type with Natural and add precondition
   --    on Value allowed range

   ---------------------------------------------------------------------------
   function HSI_Get_Calibration_Trimming
      return Natural
      with Inline;
   --  Get HSI calibration trimming

   ---------------------------------------------------------------------------
   procedure HSI48_Enable is null
      with Inline;
   --  Enable HSI48
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure HSI48_Disable is null
      with Inline;
   --  Disable HSI48
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function HSI48_Is_Ready
      return Boolean is (False)
      with Inline;
   --  Check if HSI48 oscillator ready
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function HSI48_Get_Calibration
      return Natural is (0)
      with Inline;

   ---------------------------------------------------------------------------
   procedure HSI48_Enable_Divider is null
      with Inline;
   --  Enable HSI48 divider (it divides by 6)
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure HSI48_Disable_Divider is null
      with Inline;
   --  Disable HSI48 divider (it divides by 6)
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function HSI48_Is_Divided
      return Boolean is (False)
      with Inline;
   --  Check if HSI48 divider is enabled (it divides by 6)
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure LSE_Enable
      with Inline;
   --  Enable  Low Speed External (LSE) crystal

   ---------------------------------------------------------------------------
   procedure LSE_Disable
      with Inline;
   --  Disable  Low Speed External (LSE) crystal

   ---------------------------------------------------------------------------
   procedure LSE_Enable_Bypass
      with Inline;
   --  Enable external clock source (LSE bypass)

   ---------------------------------------------------------------------------
   procedure LSE_Disable_Bypass
      with Inline;
   --  Disable external clock source (LSE bypass)

   ---------------------------------------------------------------------------
   procedure LSE_Set_Drive_Capability (Value : LSE_Drive_Type)
      with Inline;
   --  Set LSE oscillator drive capability
   --
   --  Notes:
   --  - The oscillator is in Xtal mode when it is not in bypass mode
   --  - Once “00” has been written, the content of LSEDRV cannot be changed by
   --    software.

   ---------------------------------------------------------------------------
   function LSE_Get_Drive_Capability
      return LSE_Drive_Type
      with Inline;
   --  Get LSE oscillator drive capability
   --
   --  @return Driving capability of the LSE oscillator.

   ---------------------------------------------------------------------------
   procedure LSE_Enable_CSS
      with Inline;
   --  Enable Clock Security System on LSE

   ---------------------------------------------------------------------------
   procedure LSE_Disable_CSS
      with Inline;
   --  Disable Clock Security System on LSE
   --
   --  Notes:
   --  - lock security system can be disabled only after a LSE failure
   --    detection. In that case it MUST be disabled by software.

   ---------------------------------------------------------------------------
   function LSE_Is_Ready
      return Boolean
      with Inline;
   --  Check if LSE oscillator ready

   ---------------------------------------------------------------------------
   function LSE_Is_CSS_Detected
      return Boolean
      with Inline;
   --  Check if CSS on LSE failure detection

   ---------------------------------------------------------------------------
   procedure LSI_Enable
      with Inline;
   --  Enable LSI oscillator

   ---------------------------------------------------------------------------
   procedure LSI_Disable
      with Inline;
   --  Disable LSI oscillator

   ---------------------------------------------------------------------------
   function LSI_Is_Ready
      return Boolean
      with Inline;
   --  Check if LSI is ready

   ---------------------------------------------------------------------------
   procedure MSI_Enable
      with Inline;
   --  Enable MSI oscillator

   ---------------------------------------------------------------------------
   procedure MSI_Disable
      with Inline;
   --  Disable MSI oscillator

   ---------------------------------------------------------------------------
   function MSI_Is_Ready
      return Boolean
      with Inline;
   --  Check if MSI is ready

   ---------------------------------------------------------------------------
   procedure MSI_Set_Range (Value : MSI_Range_Type)
      with Inline;
   --  Configure the Internal Multi Speed oscillator (MSI) clock range in run
   --  mode.

   ---------------------------------------------------------------------------
   function MSI_Get_Range
      return MSI_Range_Type
      with Inline;
   --  Get the Internal Multi Speed oscillator (MSI) clock range in run mode.

   ---------------------------------------------------------------------------
   function MSI_Get_Calibration
      return Natural
      with Inline;
   --  Get MSI calibration value
   --
   --  Notes:
   --  - When MSITRIM is written, MSICAL is updated with the sum of MSITRIM and
   --    the factory trim value

   ---------------------------------------------------------------------------
   procedure MSI_Set_Calibration_Trimming (Value : MSI_Trim_Calibration_Type)
      with Inline;
   --  Set MSI calibration trimming
   --
   --  Notes:
   --  - User-programmable trimming value that is added to the MSICAL
   --
   --  TODO:
   --  - Replace MSI_Trim_Calibration_Type with Natural and add precondition
   --    on Value allowed range

   ---------------------------------------------------------------------------
   function MSI_Get_Calibration_Trimming
      return Natural
      with Inline;
   --  Get MSI calibration trimming

   ---------------------------------------------------------------------------
   procedure Set_System_Clock_Source (Source : System_Clock_Source_Type)
      with Inline;
   --  Configure the system clock source

   ---------------------------------------------------------------------------
   function Get_System_Clock_Source
      return System_Clock_Source_Type
      with Inline;
   --  Get the system clock source

   ---------------------------------------------------------------------------
   procedure Set_AHB_Prescaler (Prescaler : AHB_Prescaler_Type)
      with Inline;
   --  Set AHB prescaler
   --
   --  Notes:
   --  - Depending on the device voltage range, the software has to set
   --    correctly the prescaler to ensure that the system frequency does not
   --    exceed the maximum allowed frequency

   ---------------------------------------------------------------------------
   procedure Set_APB1_Prescaler (Prescaler : APB1_Prescaler_Type)
      with Inline;
   --  Set APB1 prescaler

   ---------------------------------------------------------------------------
   procedure Set_APB2_Prescaler (Prescaler : APB2_Prescaler_Type)
      with Inline;
   --  Set APB2 prescaler

   ---------------------------------------------------------------------------
   function Get_AHB_Prescaler
      return AHB_Prescaler_Type
      with Inline;
   --  Get AHB prescaler

   ---------------------------------------------------------------------------
   function Get_APB1_Prescaler
      return APB1_Prescaler_Type
      with Inline;
   --  Get APB1 prescaler

   ---------------------------------------------------------------------------
   function Get_APB2_Prescaler
      return APB2_Prescaler_Type
      with Inline;
   --  Get APB2 prescaler

   ---------------------------------------------------------------------------
   procedure Set_Clock_After_Wake_From_Stop (Clock : Clock_After_Wake_Type)
      with Inline;
   --  Set clock after wake-up from stop mode

   ---------------------------------------------------------------------------
   function Get_Clock_After_Wake_From_Stop
      return Clock_After_Wake_Type
      with Inline;
   --  Get clock after wake-up from stop mode

   ---------------------------------------------------------------------------
   procedure Configure_MCO (Source    : MCO_Source_Type;
                            Prescaler : MCO_Prescaler_Type)
      with Inline;
   --  Configure Microcontroller clock output (MCOx)

   ---------------------------------------------------------------------------
   procedure Set_USART1_Clock_Source (Source : USART1_Source_Type)
      with Inline;
   --  Configure USART1 clock source

   ---------------------------------------------------------------------------
   procedure Set_USART2_Clock_Source (Source : USART2_Source_Type)
      with Inline;
   --  Configure USART2 clock source

   ---------------------------------------------------------------------------
   procedure Set_LPUART1_Clock_Source (Source : LPUART1_Source_Type)
      with Inline;
   --  Configure LPUART1 clock source

   ---------------------------------------------------------------------------
   procedure Set_I2C1_Clock_Source (Source : I2C1_Source_Type)
      with Inline;
   --  Configure I2C1 clock source

   ---------------------------------------------------------------------------
   procedure Set_I2C3_Clock_Source (Source : I2C3_Source_Type)
      with Inline;
   --  Configure I2C3 clock source

   ---------------------------------------------------------------------------
   procedure Set_LPTIM1_Clock_Source (Source : LPTIM1_Source_Type)
      with Inline;
   --  Configure LPTIM1 clock source

   ---------------------------------------------------------------------------
   procedure Set_RNG_Clock_Source (Source : RNG_Source_Type) is null
      with Inline;
   --  Configure RNG clock source
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure Set_USB_Clock_Source (Source : USB_Source_Type) is null
      with Inline;
   --  Configure USB clock source
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function Get_USART1_Clock_Source
      return USART1_Source_Type
      with Inline;
   --  Get USART1 clock source

   ---------------------------------------------------------------------------
   function Get_USART2_Clock_Source
      return USART2_Source_Type
      with Inline;
   --  Get USART2 clock source

   ---------------------------------------------------------------------------
   function Get_LPUART1_Clock_Source
      return LPUART1_Source_Type
      with Inline;
   --  Get LPUART1 clock source

   ---------------------------------------------------------------------------
   function Get_I2C1_Clock_Source
      return I2C1_Source_Type
      with Inline;
   --  Get I2C1 clock source

   ---------------------------------------------------------------------------
   function Get_I2C3_Clock_Source
      return I2C3_Source_Type
      with Inline;
   --  Get I2C3 clock source

   ---------------------------------------------------------------------------
   function Get_LPTIM1_Clock_Source
      return LPTIM1_Source_Type
      with Inline;
   --  Get LPTIM1 clock source

   ---------------------------------------------------------------------------
   function Get_RNG_Clock_Source
      return RNG_Source_Type
      is (RNG_Source_Type'First)
      with Inline;
   --  Get RNG clock source
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   function Get_USB_Clock_Source
      return USB_Source_Type
      is (USB_Source_Type'First)
      with Inline;
   --  Get USB clock source
   --
   --  TODO:
   --  - Implement for supported devices

   ---------------------------------------------------------------------------
   procedure Set_RTC_Clock_Source (Source : RTC_Source_Type)
      with Inline;
   --  Configure RTC clock source
   --
   --  Notes:
   --  - Once the RTC clock source has been selected, it cannot be changed any
   --    more unlessthe Backup domain is reset, or unless a failure is detected
   --    on LSE (LSECSSD is set). The RTCRST bit can be used to reset them.

   ---------------------------------------------------------------------------
   function Get_RTC_Clock_Source
      return RTC_Source_Type
      with Inline;
   --  Get RTC clock source

   ---------------------------------------------------------------------------
   procedure Enable_RTC
      with Inline;
   --  Enable RTC

   ---------------------------------------------------------------------------
   procedure Disable_RTC
      with Inline;
   --  Disable RTC

   ---------------------------------------------------------------------------
   function Is_Enabled_RTC
      return Boolean
      with Inline;
   --  Check if RTC has been enabled or not

   ---------------------------------------------------------------------------
   procedure Force_Backup_Domain_Reset
      with Inline;
   --  Force the Backup domain reset

   ---------------------------------------------------------------------------
   procedure Release_Backup_Domain_Reset
      with Inline;
   --  Release the Backup domain reset

end LL.RCC;