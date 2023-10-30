#!/bin/sh
# Update the docs
for d in ./technology/aws/*/; do
  if [ -f "$d/.terraform-docs.yml" ]; then
    if terraform-docs "$d"; then
      git add "./$d/README.md"
    fi
  fi
done
