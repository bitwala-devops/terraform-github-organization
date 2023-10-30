#!/bin/bash
GIT_ROOT_DIRECTORY="$(git rev-parse --show-toplevel)"
SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

CHECKOV_VERSION="2.0.477"

main() {
  docker run --rm \
    -v "${GIT_ROOT_DIRECTORY}:/tf" \
    -w /tf \
    "bridgecrew/checkov:${CHECKOV_VERSION}" \
    -d "${1}"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
  if [ "$CI" == "true" ] || [[ $# == 1 ]]; then
    main "$1"
  else
    TERRAFORM_DIRECTORIES="$("$SCRIPT_DIRECTORY/list_terraform_directories.sh" 2>/dev/null)"

    xargs --help &>/dev/null && replsize="" || replsize="-S 100000"

    # shellcheck disable=SC2086 # intentional word splitting
    printf '%s\n' $TERRAFORM_DIRECTORIES | xargs $replsize -n 1 -P 8 -I '{}' \
      bash -c "docker run --rm \
                -v ${GIT_ROOT_DIRECTORY}:/tf \
                -w /tf \
                bridgecrew/checkov:${CHECKOV_VERSION} \
                --quiet -d '{}' || exit 255"
  fi
fi
