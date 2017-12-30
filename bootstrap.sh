#!/usr/bin/env bash

source loader.sh

loader_addpath "$(dirname "${BASH_SOURCE[0]}")" 
loader_addpath ~/bash/shellscripts/

function bootstrap::finish() {
  loader_finish
}


