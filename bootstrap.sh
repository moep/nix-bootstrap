#!/usr/bin/env bash
# Debug only
#echo "SHELLSCRIPTS_HOME: ${SHELLSCRIPTS_HOME}"
source "${BASH_SCRIPT_PATH}/shellscriptloader-0.2/loader.sh"

loader_addpath "$(dirname "${BASH_SOURCE[0]}")" 
loader_addpath "${BASH_SCRIPT_PATH}"

function bootstrap::finish() {
  loader_finish
}
