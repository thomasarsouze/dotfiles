#!/usr/bin/env bash

for env in $(conda env list | awk '{print $1}' | grep -v "^#"); do
  echo "Installing kernel for $env"

  conda run -n "$env" \
    python -m ipykernel install \
    --user \
    --name "conda-$env" \
    --display-name "Conda: $env"
done
