/*----------------------------------------------------------------------------
--  Copyright (C) 2024, Emanuele Zarfati
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
----------------------------------------------------------------------------
--
--  Revision History:
--    2024.02 E. Zarfati
--       - First version
--
----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
  Constants
----------------------------------------------------------------------------*/

__AUINT_FLASH_BASE = 0x60000000;
__AUINT_FLASH_LEN = 0x00100000;

__AUINT_SRAM_BASE = 0x70000000;
__AUINT_SRAM_LEN = 0x00100000;

/*----------------------------------------------------------------------------
  Memories
----------------------------------------------------------------------------*/

MEMORY
{
   AUNIT_FLASH (rx) : ORIGIN = __AUINT_FLASH_BASE, LENGTH = __AUINT_FLASH_LEN
   AUNIT_SRAM (rxw) : ORIGIN = __AUINT_SRAM_BASE, LENGTH = __AUINT_SRAM_LEN
}

/*----------------------------------------------------------------------------
  Sections
----------------------------------------------------------------------------*/

/*
   FLASH
*/
SECTIONS
{
   .copyinfo :
   {
      . = ALIGN(4);
      _scopyinfo = .;

      KEEP(*(.copyinfo*))

      _ecopyinfo = .;
   } > AUNIT_FLASH
   _wcopyinfo = (_ecopyinfo - _scopyinfo) >> 2;

   .fillinfo :
   {
      . = ALIGN(4);
      _sfillinfo = .;

      KEEP(*(.fillinfo*))

      _efillinfo = .;
   } > AUNIT_FLASH
   _wfillinfo = (_efillinfo - _sfillinfo) >> 2;

   .atext :
   {
      . = ALIGN(4);
      _satext = .;

      *libaunit.a*:(.text*)

      . = ALIGN(4);
      _eatext = .;
   } > AUNIT_FLASH
   _watext = (_eatext - _satext) >> 2;
}

/*
   SRAM
 */
SECTIONS
{
   .adata :
   {
      . = ALIGN(4);
      _sadata = .;

      *libaunit.a*:(.data*)

      . = ALIGN(4);
      _eadata = .;
   } > AUNIT_SRAM AT> AUNIT_FLASH
   _wadata = (_eadata - _sadata) >> 2;
   _ladata = LOADADDR(.adata);

   .abss (NOLOAD) :
   {
      . = ALIGN(4);
      _sabss = .;

      *libaunit.a*:(.bss*)

      . = ALIGN(4);
      _eabss = .;
   } > AUNIT_SRAM
   _wabss = (_eabss - _sabss) >> 2;

   .aheap (NOLOAD) :
   {
      . = ALIGN(4);
      _saheap = .;
      __heap_start = .;

      . = ORIGIN(AUNIT_SRAM) + LENGTH(AUNIT_SRAM);

      . = ALIGN(4);
      _eaheap = .;
      __heap_end = .;
   } > AUNIT_SRAM
   _waheap = (_eaheap - _saheap) >> 2;
}