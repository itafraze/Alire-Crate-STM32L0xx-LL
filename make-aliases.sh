#!/usr/bin/env bash

# ---------------------------------------------------------------- CONSTANTS

# Base paths
TESTS_SUBDIR="tests"

CMSIS_SHARE="\\\${STM32L0XX_CMSIS_ALIRE_PREFIX}/share/stm32l0xx_cmsis/"


# ----------------------------------------------------------- AUTO CONSTANTS

# Directories
START_ABSDIR=$(pwd)
SCRIPT_ABSDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
TESTS_ABSDIR="${SCRIPT_ABSDIR}/${TESTS_SUBDIR}"

# ------------------------------------------------------------------- INPUTS

while getopts ":t" option
do
   case "${option}"
   in
      #h) HELP=1;;
      t) TRACE=1;;

      \?) error "Invalid option"
          exit;;
   esac
done

# ---------------------------------------------------------------- BASH LOGS

GREEN="\e[00;32m"
GREY="\e[00;90m"
RST="\e[00m"

info() {
   echo -e "${GREEN}INFO:\t$@${RST}"
}

trace() {
   if [[ -n "$TRACE" ]]; then
      echo -e "${GREY}TRACE:\t$@${RST}"
   fi
}

# --------------------------------------------------------- HELPER FUNCTIONS

move_to_directory()
{
   info "Moving working directory into '$@'"
   run_cmd "cd $@"
}

move_to_script_directory()
{
   if [[ "$(pwd)" != "${SCRIPT_ABSDIR}" ]] ; then
      move_to_directory "$SCRIPT_ABSDIR"
   fi
}

move_to_tests_directory()
{
   if [[ "$(pwd)" != "${TESTS_ABSDIR}" ]] ; then
      move_to_directory "$TESTS_ABSDIR"
   fi
}

move_to_start_directory()
{
   if [[ "$(pwd)" != "${START_ABSDIR}" ]] ; then
      move_to_directory "$START_ABSDIR"
   fi
   echo -e "${RST}"
}

run_cmd() {
   CMD="$@"
   if [[ -z ${TRACE} ]] ; then
      SUPPRESS=">/dev/null"
   fi
   trace ${CMD}
   eval "${CMD} ${SUPPRESS}"
   CMD="unknown"
}

# ---------------------------------------------------------------------- RUN

{
   move_to_script_directory

   # Project

   run_cmd \
      "alr settings --set alias.doc \
         \"exec -P1 -- gnatdoc --backend html --generate=body --warnings\""

   move_to_tests_directory

   # Emulation testing
   run_cmd \
      "alr settings --set alias.emu \
         \"exec -P1 arm-eabi-gnatemu --\
         -XEMU_MODE=run ./bin/tests.elf\""

   move_to_start_directory
   info "Done"
}