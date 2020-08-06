#!/usr/bin/env sh
set -e # Abort script at first error

current_branch=$(git rev-parse --abbrev-ref HEAD)
max_depth=$(git rev-list --count --no-merges master..)
args="--regex --branch ${current_branch} --max_depth=${max_depth}" # Default trufflehog options

if [ -n "${INPUT_SCANARGUMENTS}" ]; then
  args="${INPUT_SCANARGUMENTS}" # Overwrite if new options string is provided
fi

query="$args" # Build args query with repository url
res=$(trufflehog $query . | jq -s 'del(.[].diff) |del(.[].printDiff) |del(.[].stringsFound)')
if [[ "$res" != "[]" ]]; then
  echo $res | jq
  exit 1
fi
