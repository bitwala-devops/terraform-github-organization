#!/bin/bash
GIT_ROOT_DIRECTORY="$(git rev-parse --show-toplevel)"
SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# shellcheck source=/dev/null # reason: skipping source check, as the source
# is checked anyway
source "$SCRIPT_DIRECTORY/utils.sh"

DEFAULT_BRANCH="$(git remote show "$(git remote)" | grep 'HEAD branch' | cut -d ':' -f 2- | tr -d ' ')"

check_yamllint() {
  # shellcheck disable=SC2124
  local FILES=$@

  xargs --help &>/dev/null && replsize="" || replsize="-S 100000"
  command -v yamllint
  if command -v yamllint; then
     # shellcheck disable=SC2086 # intentional word splitting
     printf '%s\n' $FILES | xargs $replsize -n 1 -P 8 -I '{}' \
        bash -c "yamllint '{}' || exit 255"
  else
    # shellcheck disable=SC2086 # intentional word splitting
    printf '%s\n' $FILES | xargs $replsize -n 1 -P 8 -I '{}' \
        bash -c "docker run --rm -v ${GIT_ROOT_DIRECTORY}:/workdir:ro -w /workdir cytopia/yamllint:1.26 '{}' || exit 255"
  fi
}

main() {
  local FILES=$*
  local CHANGED_FILES=""

  (
    cd "${GIT_ROOT_DIRECTORY}" || exit 1

    if [ -n "$FILES" ]; then
      if [ "$CHECK_CHANGED_FILES" == "false" ]; then
        # shellcheck disable=SC2086 # intentional word splitting
        check_yamllint $FILES
      else
        for file in $FILES; do
          if changed "$file" "${DEFAULT_BRANCH}" >/dev/null; then
            [[ -z "$CHANGED_FILES" ]] &&
              CHANGED_FILES="$file" ||
              CHANGED_FILES="$CHANGED_FILES $file"
          fi
        done
        if [ "$CHANGED_FILES" ]; then
          # shellcheck disable=SC2086 # intentional word splitting
          check_yamllint $CHANGED_FILES
        fi
      fi
    else
      echo "No files to check."
    fi
  )
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then

  YAML_FILES="$(find . \
    -type d -name '.git' -prune -o \
    -type d -name '.terragrunt-cache' -prune -o \
    -type d -name '.terraform' -prune -o \
    -type d -name 'node_modules' -prune -o \
    -type d -name '.peru' -prune -o \
    -type d -name '.peru-deps' -prune -o \
    -type d -name 'percona-server-mongodb-operator' -prune -o \
    -type f '(' -name '*.yaml' -o -name '*.yml' ')' -print)"

  # shellcheck disable=SC2086 # intentional word splitting
  main $YAML_FILES
fi
