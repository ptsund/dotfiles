#!/usr/bin/env bash

set -euo pipefail

dmenu='dmenu -i -l 20 -p'
browser='qutebrowser'

declare -A engines
engines[google]='https://google.com/search?q='
engines[duckduckgo]='https://duckduckgo.com/?q='

engine=$(printf '%s\n' "${!engines[@]}" | sort | ${dmenu} 'Engine:' "$@")
url="${engines["${engine}"]}"
query=$(echo "$engine" | ${dmenu} 'Query:')
query="$(echo "${query}" | jq -s -R -r @uri)"
${browser} "${url}${query}"

