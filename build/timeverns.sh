#!/bin/sh
printf '\033c\033]0;%s\a' timeverns
base_path="$(dirname "$(realpath "$0")")"
"$base_path/timeverns.x86_64" "$@"
