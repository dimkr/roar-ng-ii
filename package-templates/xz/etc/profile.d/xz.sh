#!/bin/sh

# /etc/profile.d/xz.sh: environmental variables related to XZ Utils

# limit xz's memory usage to 256 MB
export XZ_DEFAULTS=--memlimit=256MiB