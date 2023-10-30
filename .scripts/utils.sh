#!/bin/bash

changed() {
  echo "# ${FUNCNAME[0]} $*"

  if [[ $# -ne 2 ]]; then
    echo "illegal number of parameters"
    echo "Usage"
    echo "  ./bin/changed.sh PATH_TO_CHECK ORIGIN"
    echo "    PATH_TO_CHECK : Path to compare"
    echo "    ORIGIN : Origin branch name to compare"
  fi

  local PATH_TO_CHECK=${1-'PLEASE_DEFINE_PATH_TO_CHECK'}
  local ORIGIN=${2-'PLEASE_DEFINE_ORIGIN_BRANCH_TO_COMPARE'}

  local CHANGED

  echo "Path to check: ${PATH_TO_CHECK}"
  echo "Origin: ${ORIGIN}"

  CHANGED="$(git diff --name-only --no-color "origin/${ORIGIN}..." -- "${PATH_TO_CHECK}")"

  if [ -z "$CHANGED" ]; then
    echo "There is no change for ${PATH_TO_CHECK} compared to ${ORIGIN}."
    return 1
  else
    echo "${PATH_TO_CHECK} is changed"
    return 0
  fi
}
