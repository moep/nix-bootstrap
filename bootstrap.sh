#!/usr/bin/env bash
# Debug only
#echo "SHELLSCRIPTS_HOME: ${SHELLSCRIPTS_HOME}"

# Set shellscripts library home to ./shellscripts ...
if [[ -z "${SHELLSCRIPTS_HOME}" ]]; then
  echo "SHELLSCRIPTS_HOME not set"
  SHELLSCRIPTS_HOME=$(dirname "${BASH_SOURCE[0]}")"/shellscripts"
  echo " --> ${SHELLSCRIPTS_HOME}"
fi

# ... and clone it if it does not exist
if [[ ! -d "${SHELLSCRIPTS_HOME}" ]]; then
  echo "Cloning shellscripts library to ${SHELLSCRIPTS_HOME}..."
  git clone https://github.com/moep/shellscripts.git "${SHELLSCRIPTS_HOME}"

  if [[ $? != 0 ]]; then
    echo "Something went wrong. Exiting."
    exit 1
  fi
fi

source "${SHELLSCRIPTS_HOME}/shellscriptloader-0.2/loader.sh"

loader_addpath "$(dirname "${BASH_SOURCE[0]}")" 
loader_addpath "${SHELLSCRIPTS_HOME}"

function bootstrap::finish() {
  loader_finish
}
