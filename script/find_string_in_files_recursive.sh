#!/usr/bin/env bash

# e.g 
# paths and line
# grep -rnw ./ --include='*' -e 'cmp --silent'
# paths only
# grep -rl --include='*' 'cmp --silent' ./

set -euo pipefail

STRING="$1"

grep -rn --include='*' -- "$STRING" . || echo "No matches found for: $STRING"