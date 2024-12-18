#!/usr/bin/env bash
GIT_ROOT_DIRECTORY="$(git rev-parse --show-toplevel)"
SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null  2>&1 && pwd)"

# shellcheck source=.scripts/utils.sh
source "$SCRIPT_DIRECTORY/utils.sh"

DEFAULT_BRANCH="$(git remote show "$(git remote)" | grep 'HEAD branch' | cut -d ':' -f 2- | tr -d ' ')"

main() {
    (
        ALL_TERRAFORM_DIRECTORIES="$(find . \
            -path '*/.terragrunt-cache/*' -prune -o \
            -path '*/.terraform/*' -prune -o \
            -name 'main.tf' -type f -print0 |
            xargs -0 -n1 dirname)"

        # shellcheck disable=SC2164
        cd "${GIT_ROOT_DIRECTORY}"

        local CHANGED=""

        if [ -n "${ALL_TERRAFORM_DIRECTORIES}" ]; then
            if [ "$CHECK_CHANGED" == "false" ]; then
                # shellcheck disable=SC2086
                echo "${ALL_TERRAFORM_DIRECTORIES}"
            else
                for terraform_directory in $ALL_TERRAFORM_DIRECTORIES; do
                    if changed "$terraform_directory" "${DEFAULT_BRANCH}" 1>&2; then
                        CHANGED="$CHANGED $terraform_directory"
                    fi
                done
                if [ "$CHANGED" ]; then
                    # shellcheck disable=SC2086
                    echo $CHANGED
                else
                    echo "No Terraform directories to check." 1>&2
                fi
            fi
        else
            echo "No Terraform directories to check." 1>&2
        fi
    )
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    main
fi
