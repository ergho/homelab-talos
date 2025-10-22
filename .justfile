#!/usr/bin/env -S just --justfile

set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

mod bootstrap
mod talos
mod kubernetes

[private]
default:
  just -l

[private]
log lvl msg *args:
    gum log -t rfc3339 -s -l "{{ lvl }}" "{{ msg }}" {{ args }}

[private]
template file args="" item="talos":
    #BW_SESSION=$(bw unlock --raw)
    if [ -z "$BW_SESSION" ]; then export BW_SESSION=$(bw unlock --raw); fi
    bw get item {{ item }} --session "$BW_SESSION" \
      | jq '[ .fields[]? | select(.name != null) | { (.name): .value } ] | add' \
      | minijinja-cli "{{ file }}" {{ args }} --format yaml -
