#!/bin/bash
#
# Wrap CutyCapt to make a quick low-overhead snapshot of a website
# Using xvfb-run to simplify things. If using in a loop, consider
# starting a proper Xvfb server and setting DISPLAY. There may be
# a downside to this however (e.g. memory leaks) so if the CPU
# overhead of start Xvfb is low, it's cleaner to just destroy and
# create a new Xvfb instance each time
#
# (C) 2020 github@mzpqnxow.com / BSD-3-Clause
#
if [ $# -ne 1 ]; then
  echo Usage:
  echo "  $0 <URL>"
  exit
fi
declare -r LOCKFILE=/tmp/.X99-lock
declare -r BASE=~/capwrap
declare -r CUTYCAPT=$(which CutyCapt)
declare -r DATE="$(date +%Y%m%d)"
declare -r OUTPATH="${BASE}/${DATE}"
# Maximum rendor in seconds
declare -r RENDER_TIMEOUT=15
# Framebuffer length/width
declare -r FB_X=1366
declare -r FB_Y=694
# Framebuffer color depth
declare -r FB_D=24
declare -r XVFB_ARGS="-screen 0, ${FB_X}x${FB_Y}x${FB_D}"
declare -r IMGFMT="png"
declare -r URL="$1"
declare -r OUTFILE="${OUTPATH}/${URL//\//@}.${IMGFMT}"

mkdir -p "${OUTPATH}"
# If LOCKFILE is not set, this will evaluate to false
# so no errors. Just comment out LOCKFILE declaration
# above if you don't want/need it
[[ -f "${LOCKFILE}" ]] && rm =-rf "${LOCKFILE}"
echo "Capturing ${URL} -> ${OUTFILE}"
xvfb-run \
   --server-args="${XVFB_ARGS}" \
   -e /dev/stdout \
  "${CUTYCAPT}" \
  --out="${OUTFILE}" \
  --url="${URL}" \
  --java=off \
  --plugins=off \
  --private-browsing=on \
  --js-can-open-windows=off \
  --js-can-access-clipboard=off \
  --print-backgrounds=on \
  --insecure \
  --max-wait="$((RENDER_TIMEOUT * 1000))" \
  --min-width="${FB_X}" \
  --min-height="${FB_Y}" \
  --out-format=png 

