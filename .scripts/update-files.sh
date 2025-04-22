#!/bin/bash
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 \${{ matrix.terraform-directory }} \${{ github.head_ref }}"
  exit 1
else
  git status
  if ! git diff --exit-code; then
    git config --global user.name "github-actions"
    git config --global user.email "$(hostname)@noreply.github.com"
    git add .
    git commit -m "chore(${1}): Auto-update $(git diff --name-only "origin/${2}" | tr '\n' ' ')"
    (git pull --rebase && git push origin "HEAD:${2}") || (git pull --rebase && git push origin "HEAD:${2}")
  fi
fi
