#!/bin/bash
GIT_ROOT_DIRECTORY="$(git rev-parse --show-toplevel)"
SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

TFLINT_BUNDLE_VERSION="v0.39.2.0"

DEFAULT_TFLINT_LOGLEVEL="error"

if [[ "$DEBUG" == true ]]; then
  TFLINT_LOGLEVEL="trace"
else
  TFLINT_LOGLEVEL="$DEFAULT_TFLINT_LOGLEVEL"
fi

main() {
  docker run --rm \
    -v "${GIT_ROOT_DIRECTORY}:/data" \
    -w "/data" \
    "ghcr.io/terraform-linters/tflint-bundle:${TFLINT_BUNDLE_VERSION}" \
    --loglevel="$TFLINT_LOGLEVEL" "${1}"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
  if [ "$CI" == "true" ] || [[ $# == 1 ]]; then
    main "$1"
  else
    TERRAFORM_DIRECTORIES="$("$SCRIPT_DIRECTORY/list_terraform_directories.sh" 2>/dev/null)"

    xargs --help &>/dev/null && replsize="" || replsize="-S 100000"

    # shellcheck disable=SC2086 # intentional word splitting
    printf '%s\n' $TERRAFORM_DIRECTORIES | xargs $replsize -n 1 -P 8 -I '{}' \
      bash -c "docker run --rm -v ${GIT_ROOT_DIRECTORY}:/data -w /data ghcr.io/terraform-linters/tflint-bundle:${TFLINT_BUNDLE_VERSION} --loglevel=${TFLINT_LOGLEVEL} {} || exit 255"
  fi
fi
