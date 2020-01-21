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
if [ $# -lt 3 ]; then
  echo Usage:
  echo "  $0 <HOST> <PROTOCOL> <PORT> [URI]"
  exit
fi
declare -r NC_TIMEOUT=5
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
declare -r SCREEN=0
# No modern Xorg build defaults to TCP listen anymore, but best to be explicit
declare -r XVFB_ARGS="-screen ${SCREEN}, ${FB_X}x${FB_Y}x${FB_D} -nolisten tcp"
declare -r IMGFMT="png"
declare -r HOST="$1"
declare -r PROTOCOL="$2"
declare -r PORT="$3"
# URI must start with a / if it is specified ...
declare -r URI="$4"
declare -r URL="${PROTOCOL}://${HOST}:${PORT}${URI}"
declare -r OUTFILE="${OUTPATH}/${URL//\//@}.${IMGFMT}"

# If the port is closed or filtered, do not bother invoking Xvfb and wasting resources
echo -n "Testing open port ${HOST}:${PORT} with ${NC_TIMEOUT} second timeout ... "
nc -z -w "${NC_TIMEOUT}" "${HOST}" "${PORT}"
if [ $? -ne 0 ]; then
  echo 'not open, exiting!'
  exit
fi
echo 'open, continuing!'
mkdir -p "${OUTPATH}"
# If LOCKFILE is not set, this will evaluate to false
# so no errors. Just comment out LOCKFILE declaration
# above if you don't want/need it. There is a cleaner
# way to avoid the locking issue, and it is probably
# symptomatic of a larger issue but for now this works
# fine and all of the screencaps work, so meh
[[ -f "${LOCKFILE}" ]] && rm -rf "${LOCKFILE}"
echo "Capturing ${URL} -> ${OUTFILE}"
xvfb-run \
  -a \
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

