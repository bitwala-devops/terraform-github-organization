#!/bin/bash

GIT_ROOT_DIRECTORY="$(git rev-parse --show-toplevel)"
SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# shellcheck source=/dev/null # reason: skipping source check, as the source
# is checked anyway
source "$SCRIPT_DIRECTORY/utils.sh"

DEFAULT_BRANCH=$(git remote show "$(git remote)" | awk '/HEAD branch/ {print $NF}' | tr -d ' ')

check_shellcheck() {
  local FILES=$*
  docker pull koalaman/shellcheck-alpine:latest
  # shellcheck disable=SC2086
  echo $FILES | xargs -n 1 -P 8 docker run --rm -w /mnt/ -v "${GIT_ROOT_DIRECTORY}:/mnt/:ro" koalaman/shellcheck-alpine:latest shellcheck -x
}

main() {
  local FILES=$*

  (
    cd "${GIT_ROOT_DIRECTORY}" || exit 1

    local CHANGED=""

    if [ -n "$FILES" ]; then
      if [ "$CHECK_CHANGED" = "false" ]; then
        # shellcheck disable=SC2086
        check_shellcheck $FILES
      else
        for file in $FILES; do
          if changed "$file" "${DEFAULT_BRANCH}"; then
            CHANGED="$CHANGED $file"
          fi
        done
        if [ -n "$CHANGED" ]; then
          # shellcheck disable=SC2086
          check_shellcheck $CHANGED
        fi
      fi
    else
      echo "No files to check."
    fi
  )
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
  SHELL_SCRIPT_FILES="$(find . \
    -type d -name '.git' -prune -o \
    -type d -name '.terragrunt-cache' -prune -o \
    -type d -name '.terraform' -prune -o \
    -type d -name 'node_modules' -prune -o \
    -type d -name '.peru' -prune -o \
    -type d -name '.peru-deps' -prune -o \
    -type d -name 'percona-server-mongodb-operator' -prune -o \
    -type f -print0 | xargs -0 file | grep --line-buffered 'shell script\|\/usr\/bin\/env bash script\|zsh script' | cut -d ':' -f 1)"
  main "$SHELL_SCRIPT_FILES"
fi
