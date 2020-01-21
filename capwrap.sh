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

# Maximum rendor in seconds
declare -r RENDER_TIMEOUT=90
# Framebuffer length/width
declare -r FB_X=1366
declare -r FB_Y=694
# Framebuffer color depth
declare -r FB_D=24
declare -r XVFB_ARGS="-screen 0, ${FB_X}x${FB_Y}x${FB_D}"
declare -r IMGFMT="png"
declare -r URL="$1"
declare -r OUTFILE="${URL//\//@}.${IMGFMT}"
echo "Capturing ${URL} -> ${OUTFILE}"
xvfb-run \
   --server-args="${XVFB_ARGS}" \
   -e /dev/stdout \
  ./CutyCapt \
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

