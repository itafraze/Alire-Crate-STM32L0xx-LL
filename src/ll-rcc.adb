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
   use CMSIS.Device.RCC;
with CMSIS.Device.RCC.Instances;
   use CMSIS.Device.RCC.Instances;

package body LL.RCC is
   --  Reset and Clock Control (RCC) low-level driver
   --
   --  Implementation notes:
   --  - Based on source files:
   --    - stm32l0xx_hal_driver:Inc/stm32l0xx_ll_rcc.h
   --    - stm32l0xx_hal_driver:Src/stm32l0xx_ll_rcc.c

   RCC renames CMSIS.Device.RCC.Instances.RCC;
   --  Force RCC to represent the instance instead of this child package

   ---------------------------------------------------------------------------
   procedure HSE_Enable_Bypass is
   begin

      RCC.CR.HSEBYP := CR_HSEBYP_Field (2#1#);

   end HSE_Enable_Bypass;

   ---------------------------------------------------------------------------
   procedure HSE_Disable_Bypass is
   begin

      RCC.CR.HSEBYP := CR_HSEBYP_Field (2#0#);

   end HSE_Disable_Bypass;

   ---------------------------------------------------------------------------
   procedure HSE_Enable is
   begin

      RCC.CR.HSEON := CR_HSEON_Field (2#1#);

   end HSE_Enable;

   ---------------------------------------------------------------------------
   procedure HSE_Disable is
   begin

      RCC.CR.HSEON := CR_HSEON_Field (2#0#);

   end HSE_Disable;

   ---------------------------------------------------------------------------
   function HSE_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CR.HSERDY));

   ---------------------------------------------------------------------------
   procedure Set_RTC_HSE_Prescaler (HSE_Prescaler : HSE_Prescaler_Type) is
   begin

      RCC.CR.RTCPRE := CR_RTCPRE_Field (
         HSE_Prescaler_Type'Pos (HSE_Prescaler));

   end Set_RTC_HSE_Prescaler;

   ---------------------------------------------------------------------------
   function Get_RTC_HSE_Prescaler
      return HSE_Prescaler_Type is
      (HSE_Prescaler_Type'Val (RCC.CR.RTCPRE));

   ---------------------------------------------------------------------------
   procedure HSI_Enable is
   begin

      RCC.CR.HSI16ON := CR_HSI16ON_Field (2#1#);

   end HSI_Enable;

   ---------------------------------------------------------------------------
   procedure HSI_Disable is
   begin

      RCC.CR.HSI16ON := CR_HSI16ON_Field (2#0#);

   end HSI_Disable;

   ---------------------------------------------------------------------------
   function HSI_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CR.HSI16RDYF));

   ---------------------------------------------------------------------------
   procedure HSI_Enable_In_Stop_Mode is
   begin

      RCC.CR.HSI16KERON := CR_HSI16KERON_Field (2#1#);

   end HSI_Enable_In_Stop_Mode;

   ---------------------------------------------------------------------------
   procedure HSI_Disable_In_Stop_Mode is
   begin

      RCC.CR.HSI16KERON := CR_HSI16KERON_Field (2#0#);

   end HSI_Disable_In_Stop_Mode;

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Divider is
   begin

      RCC.CR.HSI16DIVEN := CR_HSI16DIVEN_Field (2#1#);

   end HSI_Enable_Divider;

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Divider is
   begin

      RCC.CR.HSI16DIVEN := CR_HSI16DIVEN_Field (2#0#);

   end HSI_Disable_Divider;

   ---------------------------------------------------------------------------
   procedure HSI_Enable_Output is
   begin

      RCC.CR.HSI16OUTEN := CR_HSI16OUTEN_Field (2#1#);

   end HSI_Enable_Output;

   ---------------------------------------------------------------------------
   procedure HSI_Disable_Output is
   begin

      RCC.CR.HSI16OUTEN := CR_HSI16OUTEN_Field (2#0#);

   end HSI_Disable_Output;

   ---------------------------------------------------------------------------
   function HSI_Get_Calibration
      return Natural is
      (Natural (RCC.ICSCR.HSI16CAL));

   ---------------------------------------------------------------------------
   procedure HSI_Set_Calibration_Trimming (
      Value : HSI_Trim_Calibration_Type) is
   begin

      RCC.ICSCR.HSI16TRIM := Value;

   end HSI_Set_Calibration_Trimming;

   ---------------------------------------------------------------------------
   function HSI_Get_Calibration_Trimming
      return Natural is
      (Natural (RCC.ICSCR.HSI16TRIM));

   ---------------------------------------------------------------------------
   procedure LSE_Enable is
   begin

      RCC.CSR.LSEON := CSR_LSEON_Field (2#1#);

   end LSE_Enable;

   ---------------------------------------------------------------------------
   procedure LSE_Disable is
   begin

      RCC.CSR.LSEON := CSR_LSEON_Field (2#0#);

   end LSE_Disable;

   ---------------------------------------------------------------------------
   procedure LSE_Enable_Bypass is
   begin

      RCC.CSR.LSEBYP := CSR_LSEBYP_Field (2#1#);

   end LSE_Enable_Bypass;

   ---------------------------------------------------------------------------
   procedure LSE_Disable_Bypass is
   begin

      RCC.CSR.LSEBYP := CSR_LSEBYP_Field (2#0#);

   end LSE_Disable_Bypass;

   ---------------------------------------------------------------------------
   procedure LSE_Set_Drive_Capability (Value : LSE_Drive_Type) is
   begin

      RCC.CSR.LSEDRV := CSR_LSEDRV_Field (LSE_Drive_Type'Pos (Value));

   end LSE_Set_Drive_Capability;

   ---------------------------------------------------------------------------
   function LSE_Get_Drive_Capability
      return LSE_Drive_Type is
      (LSE_Drive_Type'Val (RCC.CSR.LSEDRV));

   ---------------------------------------------------------------------------
   procedure LSE_Enable_CSS is
   begin

      RCC.CSR.CSSLSEON := CSR_CSSLSEON_Field (2#1#);

   end LSE_Enable_CSS;

   ---------------------------------------------------------------------------
   procedure LSE_Disable_CSS is
   begin

      RCC.CSR.CSSLSEON := CSR_CSSLSEON_Field (2#0#);

   end LSE_Disable_CSS;

   ---------------------------------------------------------------------------
   function LSE_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CSR.LSERDY));

   ---------------------------------------------------------------------------
   function LSE_Is_CSS_Detected
      return Boolean is
      (Boolean'Val (RCC.CSR.CSSLSED));

   ---------------------------------------------------------------------------
   procedure LSI_Enable is
   begin

      RCC.CSR.LSION := CSR_LSION_Field (2#1#);

   end LSI_Enable;

   ---------------------------------------------------------------------------
   procedure LSI_Disable is
   begin

      RCC.CSR.LSION := CSR_LSION_Field (2#0#);

   end LSI_Disable;

   ---------------------------------------------------------------------------
   function LSI_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CSR.LSIRDY));

   ---------------------------------------------------------------------------
   procedure MSI_Enable is
   begin

      RCC.CR.MSION := CR_MSION_Field (2#1#);

   end MSI_Enable;

   ---------------------------------------------------------------------------
   procedure MSI_Disable is
   begin

      RCC.CR.MSION := CR_MSION_Field (2#0#);

   end MSI_Disable;

   ---------------------------------------------------------------------------
   function MSI_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CR.MSIRDY));

   ---------------------------------------------------------------------------
   procedure MSI_Set_Range (Value : MSI_Range_Type) is
   begin

      RCC.ICSCR.MSIRANGE := ICSCR_MSIRANGE_Field (
         MSI_Range_Type'Pos (Value));

   end MSI_Set_Range;

   ---------------------------------------------------------------------------
   function MSI_Get_Range
      return MSI_Range_Type is
      (MSI_Range_Type'Val (RCC.ICSCR.MSIRANGE));

   ---------------------------------------------------------------------------
   function MSI_Get_Calibration
      return Natural is
      (Natural (RCC.ICSCR.MSICAL));

   ---------------------------------------------------------------------------
   procedure MSI_Set_Calibration_Trimming (
      Value : MSI_Trim_Calibration_Type) is
   begin

      RCC.ICSCR.MSITRIM := Value;

   end MSI_Set_Calibration_Trimming;

   ---------------------------------------------------------------------------
   function MSI_Get_Calibration_Trimming
      return Natural is
      (Natural (RCC.ICSCR.MSITRIM));

   ---------------------------------------------------------------------------
   procedure Set_System_Clock_Source (Source : System_Clock_Source_Type) is
   begin

      RCC.CFGR.SW := CFGR_SW_Field (System_Clock_Source_Type'Pos (Source));

   end Set_System_Clock_Source;

   ---------------------------------------------------------------------------
   function Get_System_Clock_Source
      return System_Clock_Source_Type is
      (System_Clock_Source_Type'Val (RCC.CFGR.SWS));

   ---------------------------------------------------------------------------
   procedure Set_AHB_Prescaler (Prescaler : AHB_Prescaler_Type) is
   begin

      RCC.CFGR.HPRE := CFGR_HPRE_Field (case Prescaler is
         when DIV_2 .. DIV_512 =>
            AHB_Prescaler_Type'Pos (Prescaler)
               + 2#1000# - AHB_Prescaler_Type'Pos (DIV_2),
         when others => 2#0#);

   end Set_AHB_Prescaler;

   ---------------------------------------------------------------------------
   procedure Set_APB1_Prescaler (Prescaler : APB1_Prescaler_Type) is
   begin

      RCC.CFGR.PPRE.Arr (1) := CFGR_PPRE_Element (case Prescaler is
         when DIV_2 .. DIV_16 =>
            APB1_Prescaler_Type'Pos (Prescaler)
               + 2#100# - APB1_Prescaler_Type'Pos (DIV_2),
         when others => 2#0#);

   end Set_APB1_Prescaler;

   ---------------------------------------------------------------------------
   procedure Set_APB2_Prescaler (Prescaler : APB2_Prescaler_Type) is
   begin

      RCC.CFGR.PPRE.Arr (2) := CFGR_PPRE_Element (case Prescaler is
         when DIV_2 .. DIV_16 =>
            APB2_Prescaler_Type'Pos (Prescaler)
               + 2#100# - APB2_Prescaler_Type'Pos (DIV_2),
         when others => 2#0#);

   end Set_APB2_Prescaler;

   ---------------------------------------------------------------------------
   function Get_AHB_Prescaler
      return AHB_Prescaler_Type is
      --
      use all type CFGR_HPRE_Field;
      --
      Prescaler : AHB_Prescaler_Type;
   begin

      Prescaler := AHB_Prescaler_Type'Val (case RCC.CFGR.HPRE is
         when 2#1000# .. 2#1111# =>
            (RCC.CFGR.HPRE - 2#1000#) + AHB_Prescaler_Type'Pos (DIV_2),
         when others => 2#0#);

      return Prescaler;

   end Get_AHB_Prescaler;

   ---------------------------------------------------------------------------
   function Get_APB1_Prescaler
      return APB1_Prescaler_Type is
      --
      use all type CFGR_PPRE_Element;
      --
      Prescaler : APB1_Prescaler_Type;
   begin

      Prescaler := APB1_Prescaler_Type'Val (case RCC.CFGR.PPRE.Arr (1) is
         when 2#100# .. 2#111# =>
            (RCC.CFGR.PPRE.Arr (1) - 2#100#) + APB1_Prescaler_Type'Pos (DIV_2),
         when others => 2#0#);

      return Prescaler;

   end Get_APB1_Prescaler;

   ---------------------------------------------------------------------------
   function Get_APB2_Prescaler
      return APB2_Prescaler_Type is
      --
      use all type CFGR_PPRE_Element;
      --
      Prescaler : APB2_Prescaler_Type;
   begin

      Prescaler := APB2_Prescaler_Type'Val (case RCC.CFGR.PPRE.Arr (2) is
         when 2#100# .. 2#111# =>
            (RCC.CFGR.PPRE.Arr (2) - 2#100#) + APB2_Prescaler_Type'Pos (DIV_2),
         when others => 2#0#);

      return Prescaler;

   end Get_APB2_Prescaler;

   ---------------------------------------------------------------------------
   procedure Set_Clock_After_Wake_From_Stop (Clock : Clock_After_Wake_Type) is
   begin

      RCC.CFGR.STOPWUCK := CFGR_STOPWUCK_Field (
         Clock_After_Wake_Type'Pos (Clock));

   end Set_Clock_After_Wake_From_Stop;

   ---------------------------------------------------------------------------
   function Get_Clock_After_Wake_From_Stop
      return Clock_After_Wake_Type is
      (Clock_After_Wake_Type'Val (RCC.CFGR.STOPWUCK));

   ---------------------------------------------------------------------------
   procedure Configure_MCO (Source    : MCO_Source_Type;
                            Prescaler : MCO_Prescaler_Type) is
   begin

      RCC.CFGR := (@ with delta
         MCOSEL => CFGR_MCOSEL_Field (MCO_Source_Type'Pos (Source)),
         MCOPRE => CFGR_MCOPRE_Field (MCO_Prescaler_Type'Pos (Prescaler)));

   end Configure_MCO;

   ---------------------------------------------------------------------------
   procedure Set_USART1_Clock_Source (Source : USART1_Source_Type) is
   begin

      RCC.CCIPR.USART1SEL.Val := USART1_Source_Type'Pos (Source);

   end Set_USART1_Clock_Source;

   ---------------------------------------------------------------------------
   procedure Set_USART2_Clock_Source (Source : USART2_Source_Type) is
   begin

      RCC.CCIPR.USART2SEL.Val := USART2_Source_Type'Pos (Source);

   end Set_USART2_Clock_Source;

   ---------------------------------------------------------------------------
   procedure Set_LPUART1_Clock_Source (Source : LPUART1_Source_Type) is
   begin

      RCC.CCIPR.LPUART1SEL.Val := LPUART1_Source_Type'Pos (Source);

   end Set_LPUART1_Clock_Source;

   ---------------------------------------------------------------------------
   procedure Set_I2C1_Clock_Source (Source : I2C1_Source_Type) is
   begin

      RCC.CCIPR.I2C1SEL.Val := (I2C1_Source_Type'Pos (Source));

   end Set_I2C1_Clock_Source;

   ---------------------------------------------------------------------------
   procedure Set_I2C3_Clock_Source (Source : I2C3_Source_Type) is
   begin

      RCC.CCIPR.I2C3SEL.Val := (I2C3_Source_Type'Pos (Source));

   end Set_I2C3_Clock_Source;

   ---------------------------------------------------------------------------
   procedure Set_LPTIM1_Clock_Source (Source : LPTIM1_Source_Type) is
   begin

      RCC.CCIPR.LPTIM1SEL.Val := (LPTIM1_Source_Type'Pos (Source));

   end Set_LPTIM1_Clock_Source;

   ---------------------------------------------------------------------------
   function Get_USART1_Clock_Source
      return USART1_Source_Type is
      (USART1_Source_Type'Val (RCC.CCIPR.USART1SEL.Val));

   ---------------------------------------------------------------------------
   function Get_USART2_Clock_Source
      return USART2_Source_Type is
      (USART2_Source_Type'Val (RCC.CCIPR.USART2SEL.Val));

   ---------------------------------------------------------------------------
   function Get_LPUART1_Clock_Source
      return LPUART1_Source_Type is
      (LPUART1_Source_Type'Val (RCC.CCIPR.LPUART1SEL.Val));

   ---------------------------------------------------------------------------
   function Get_I2C1_Clock_Source
      return I2C1_Source_Type is
      (I2C1_Source_Type'Val (RCC.CCIPR.I2C1SEL.Val));

   ---------------------------------------------------------------------------
   function Get_I2C3_Clock_Source
      return I2C3_Source_Type is
      (I2C3_Source_Type'Val (RCC.CCIPR.I2C3SEL.Val));

   ---------------------------------------------------------------------------
   function Get_LPTIM1_Clock_Source
      return LPTIM1_Source_Type is
      (LPTIM1_Source_Type'Val (RCC.CCIPR.LPTIM1SEL.Val));

   ---------------------------------------------------------------------------
   procedure Set_RTC_Clock_Source (Source : RTC_Source_Type) is
   begin

      RCC.CSR.RTCSEL := CSR_RTCSEL_Field (RTC_Source_Type'Pos (Source));

   end Set_RTC_Clock_Source;

   ---------------------------------------------------------------------------
   function Get_RTC_Clock_Source
      return RTC_Source_Type is
      (RTC_Source_Type'Val (RCC.CSR.RTCSEL));

   ---------------------------------------------------------------------------
   procedure Enable_RTC is
   begin

      RCC.CSR.RTCEN := CSR_RTCEN_Field (2#1#);

   end Enable_RTC;

   ---------------------------------------------------------------------------
   procedure Disable_RTC is
   begin

      RCC.CSR.RTCEN := CSR_RTCEN_Field (2#0#);

   end Disable_RTC;

   ---------------------------------------------------------------------------
   function Is_Enabled_RTC
      return Boolean is
      (Boolean'Val (RCC.CSR.RTCEN));

   ---------------------------------------------------------------------------
   procedure Force_Backup_Domain_Reset is
   begin

      RCC.CSR.RTCRST := CSR_RTCRST_Field (2#1#);

   end Force_Backup_Domain_Reset;

   ---------------------------------------------------------------------------
   procedure Release_Backup_Domain_Reset is
   begin

      RCC.CSR.RTCRST := CSR_RTCRST_Field (2#0#);

   end Release_Backup_Domain_Reset;

   ---------------------------------------------------------------------------
   procedure PLL_Enable is
   begin

      RCC.CR.PLLON := CR_PLLON_Field (2#1#);

   end PLL_Enable;

   ---------------------------------------------------------------------------
   procedure PLL_Disable is
   begin

      RCC.CR.PLLON := CR_PLLON_Field (2#0#);

   end PLL_Disable;

   ---------------------------------------------------------------------------
   function PLL_Is_Ready
      return Boolean is
      (Boolean'Val (RCC.CR.PLLRDY));

   ---------------------------------------------------------------------------
   procedure PLL_Configure_Domain_SYS (Source   : PLL_Source_Type;
                                       Multiply : PLL_Multiplicator_Type;
                                       Divide   : PLL_Divider_Type) is
   begin

      RCC.CFGR := (@ with delta
         PLLSRC => CFGR_PLLSRC_Field (PLL_Source_Type'Pos (Source)),
         PLLMUL => CFGR_PLLMUL_Field (PLL_Multiplicator_Type'Pos (Multiply)),
         PLLDIV => CFGR_PLLDIV_Field (PLL_Divider_Type'Pos (Divide))
      );

   end PLL_Configure_Domain_SYS;

   ---------------------------------------------------------------------------
   procedure PLL_Set_Main_Source (Source : PLL_Source_Type) is
   begin

      RCC.CFGR.PLLSRC := CFGR_PLLSRC_Field (PLL_Source_Type'Pos (Source));

   end PLL_Set_Main_Source;

   ---------------------------------------------------------------------------
   function PLL_Get_Main_Source
      return PLL_Source_Type is
      (PLL_Source_Type'Val (RCC.CFGR.PLLSRC));

   ---------------------------------------------------------------------------
   function PLL_Get_Multiplicator
      return PLL_Multiplicator_Type is
      (PLL_Multiplicator_Type'Val (RCC.CFGR.PLLMUL));

   ---------------------------------------------------------------------------
   function PLL_Get_Divider
      return PLL_Divider_Type is
      (PLL_Divider_Type'Val (RCC.CFGR.PLLDIV));

   ---------------------------------------------------------------------------
   procedure Clear_Flag_LSIRDY is
   begin

      RCC.CICR.LSIRDYC := CICR_LSIRDYC_Field (2#1#);

   end Clear_Flag_LSIRDY;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_LSERDY is
   begin

      RCC.CICR.LSERDYC := CICR_LSERDYC_Field (2#1#);

   end Clear_Flag_LSERDY;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_MSIRDY is
   begin

      RCC.CICR.MSIRDYC := CICR_MSIRDYC_Field (2#1#);

   end Clear_Flag_MSIRDY;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HSIRDY is
   begin

      RCC.CICR.HSI16RDYC := CICR_HSI16RDYC_Field (2#1#);

   end Clear_Flag_HSIRDY;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HSERDY is
   begin

      RCC.CICR.HSERDYC := CICR_HSERDYC_Field (2#1#);

   end Clear_Flag_HSERDY;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_PLLRDY is
   begin

      RCC.CICR.PLLRDYC := CICR_PLLRDYC_Field (2#1#);

   end Clear_Flag_PLLRDY;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_HSECSS is
   begin

      RCC.CICR.CSSHSEC := CICR_CSSHSEC_Field (2#1#);

   end Clear_Flag_HSECSS;

   ---------------------------------------------------------------------------
   procedure Clear_Flag_LSECSS is
   begin

      RCC.CICR.CSSLSEC := CICR_CSSLSEC_Field (2#1#);

   end Clear_Flag_LSECSS;

   ---------------------------------------------------------------------------
   function Is_Active_Flag_LSIRDY
      return Boolean is
      (Boolean'Val (RCC.CIFR.LSIRDYF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_LSERDY
      return Boolean is
      (Boolean'Val (RCC.CIFR.LSERDYF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_MSIRDY
      return Boolean is
      (Boolean'Val (RCC.CIFR.MSIRDYF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HSIRDY
      return Boolean is
      (Boolean'Val (RCC.CIFR.HSI16RDYF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HSERDY
      return Boolean is
      (Boolean'Val (RCC.CIFR.HSERDYF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_PLLRDY
      return Boolean is
      (Boolean'Val (RCC.CIFR.PLLRDYF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HSECSS
      return Boolean is
      (Boolean'Val (RCC.CIFR.CSSHSEF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_LSECSS
      return Boolean is
      (Boolean'Val (RCC.CIFR.CSSHSEF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_HSIDIV
      return Boolean is
      (Boolean'Val (RCC.CR.HSI16DIVF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_FWRST
      return Boolean is
      (Boolean'Val (RCC.CSR.FWRSTF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_IWDGRST
      return Boolean is
      (Boolean'Val (RCC.CSR.IWDGRSTF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_LPWRRST
      return Boolean is
      (Boolean'Val (RCC.CSR.LPWRSTF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_OBLRST
      return Boolean is
      (Boolean'Val (RCC.CSR.OBLRSTF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_PINRST
      return Boolean is
      (Boolean'Val (RCC.CSR.PINRSTF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_PORRST
      return Boolean is
      (Boolean'Val (RCC.CSR.PORRSTF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_SFTRST
      return Boolean is
      (Boolean'Val (RCC.CSR.SFTRSTF));

   ---------------------------------------------------------------------------
   function Is_Active_Flag_WWDGRST
      return Boolean is
      (Boolean'Val (RCC.CSR.WWDGRSTF));

   ---------------------------------------------------------------------------
   procedure Clear_Reset_Flags is
   begin

      RCC.CSR.RMVF := CSR_RMVF_Field (2#1#);

   end Clear_Reset_Flags;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_LSIRDY is
   begin

      RCC.CIER.LSIRDYIE := CIER_LSIRDYIE_Field (2#1#);

   end Enable_Interrupt_LSIRDY;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_LSERDY is
   begin

      RCC.CIER.LSERDYIE := CIER_LSERDYIE_Field (2#1#);

   end Enable_Interrupt_LSERDY;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_MSIRDY is
   begin

      RCC.CIER.MSIRDYIE := CIER_MSIRDYIE_Field (2#1#);

   end Enable_Interrupt_MSIRDY;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_HSIRDY is
   begin

      RCC.CIER.HSI16RDYIE := CIER_HSI16RDYIE_Field (2#1#);

   end Enable_Interrupt_HSIRDY;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_HSERDY is
   begin

      RCC.CIER.HSERDYIE := CIER_HSERDYIE_Field (2#1#);

   end Enable_Interrupt_HSERDY;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_PLLRDY is
   begin

      RCC.CIER.PLLRDYIE := CIER_PLLRDYIE_Field (2#1#);

   end Enable_Interrupt_PLLRDY;

   ---------------------------------------------------------------------------
   procedure Enable_Interrupt_LSECSS is
   begin

      RCC.CIER.CSSLSE := CIER_CSSLSE_Field (2#1#);

   end Enable_Interrupt_LSECSS;

end LL.RCC;