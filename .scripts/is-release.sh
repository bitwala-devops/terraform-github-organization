#!/bin/bash

# Check if there will be at least one bullet item in the generated CHANGELOG.md
if ! npm run standard-version -- --dry-run | grep -q '^\*'; then
    # No semantically relevant changes, no version bump or tag is needed. This
    # check also prevents an infinite loop in the build pipeline, since the new
    # "chore(release)" commit will not be semantically relevant.
    echo "No semantically relevant changes found."
    if [[ "$CI" == "true" ]]; then
     echo "::set-output name=bool::false"
  fi
else
  echo "Semantically relevant changes found."
  if [[ "$CI" == "true" ]]; then
     echo "::set-output name=bool::true"
  fi
fi
