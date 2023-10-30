#!/bin/bash
GIT_ROOT_DIRECTORY="$(git rev-parse --show-toplevel)"
SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

TERRAFORM_VERSION="1.5.0"

CACHE_DIR=/tmp/bin/

setup_terraform() {
  (
    mkdir -p "${CACHE_DIR}"
    cd "$CACHE_DIR" || exit
    if [[ "$(uname -m)" == "x86_64" ]]; then
      architecture="amd64"
    else
      architecture="$(uname -m)"
    fi

    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_$(uname -s | tr '[:upper:]' '[:lower:]')_${architecture}.zip"
    unzip "terraform_${TERRAFORM_VERSION}_$(uname -s | tr '[:upper:]' '[:lower:]')_${architecture}.zip"
    rm "terraform_${TERRAFORM_VERSION}_$(uname -s | tr '[:upper:]' '[:lower:]')_${architecture}.zip"
  )
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
  if [[ "$CI" == "true" ]] || [[ $# == 1 ]]; then
    if [[ "$CI" == "true" ]]; then
      if [[ ! -f "${CACHE_DIR}/terraform" ]]; then
        echo "Installing Terraform to ${CACHE_DIR}"
        setup_terraform
        echo "Using $("${CACHE_DIR}/terraform" -v | head -n1)..."
      else
        echo "Using cached $("${CACHE_DIR}/terraform" -v | head -n1) from ${CACHE_DIR}..."
      fi

      cd "$1" && "${CACHE_DIR}/terraform" fmt -check -recursive -diff
    else
      echo "Using $(terraform -v | head -n1)"
      echo "$1"
      (cd "$1" && terraform fmt -check -recursive -diff -write=true -list=true)
    fi
  else
    echo "Using $(terraform -v | head -n1)"
    TERRAFORM_DIRECTORIES="$("$SCRIPT_DIRECTORY/list_terraform_directories.sh" 2>/dev/null)"

    xargs --help &>/dev/null && replsize="" || replsize="-S 100000"

    # shellcheck disable=SC2086 # intentional word splitting
    printf '%s\n' $TERRAFORM_DIRECTORIES | xargs $replsize -n 1 -P 8 -I '{}' \
      bash -c "cd ${GIT_ROOT_DIRECTORY}/{} && terraform fmt -check -recursive -diff -write=false -list=true || exit 255"
    CHECK_EXIT_CODE=$?
    if [[ "$LAST_EXIT_CODE" == "1" ]]; then
        # shellcheck disable=SC2086 # intentional word splitting
        printf '%s\n' $TERRAFORM_DIRECTORIES | xargs $replsize -n 1 -P 8 -I '{}' \
          bash -c "cd ${GIT_ROOT_DIRECTORY}/{} && terraform fmt -recursive -write=true || exit 255"
        FIX_EXIT_CODE=$?
    fi
    if [[ -n "$FIX_EXIT_CODE" ]]; then
        if [[ "$FIX_EXIT_CODE" == "0" ]]; then
            exit "$CHECK_EXIT_CODE"
        else
            exit "$FIX_EXIT_CODE"
        fi
    else
        exit "$CHECK_EXIT_CODE"
    fi
  fi
fi
