#!/bin/bash
set -eu

imok=/sys/bus/platform/devices/INT3400:00/imok

if [[ -w "${imok}" ]]; then
    printf '1\n' > "${imok}"
fi
