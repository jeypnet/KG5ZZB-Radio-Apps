#!/bin/bash
# Tests the Linux download the way a new user meets it: unpack, first start, pick a city, test sound,
# the demo with sound, every screen, a restart, and the free basic version after the 30 days.
# $1 = the downloaded .tar.gz, $2 = a short name for the result files.
set -euo pipefail
TAR=$(realpath "$1"); NAME=$2; HERE=$(dirname "$(realpath "$0")"); OUT=$PWD/out-$NAME
mkdir -p "$OUT"
SUDO=""; [ "$(id -u)" = 0 ] || SUDO=sudo

echo "::group::Test tools"
# Test tools (screen, OCR, sound) plus the desktop libraries every Linux desktop already has.
if command -v apt-get >/dev/null; then
  $SUDO apt-get update -qq
  $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq xvfb xdotool openbox tesseract-ocr imagemagick \
    pulseaudio pulseaudio-utils libusb-1.0-0 libfontconfig1 libice6 libsm6 python3 udev procps >/dev/null
else
  dnf install -y -q --skip-unavailable xorg-x11-server-Xvfb xdotool openbox tesseract tesseract-langpack-eng ImageMagick \
    pulseaudio pulseaudio-utils libusb1 fontconfig libICE libSM python3 systemd-udev procps-ng >/dev/null
fi
grep PRETTY_NAME /etc/os-release
echo "::endgroup::"

# A brand-new user: empty home folder, the download unpacked in Downloads.
HOME=$(mktemp -d); export HOME
unset XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_STATE_HOME
mkdir -p "$HOME/Downloads"; cd "$HOME/Downloads"
tar -xzf "$TAR"
DIR=KG5ZZB-SDR-Airband-Receiver-linux-x64
APP="$PWD/$DIR/KG5ZZB-SDR-Airband-Receiver"
LOG="$HOME/.config/KG5ZZB-SDR-Airband-Receiver/log.txt"
if [ -x "$APP" ]; then echo "OK: the app file is executable after unpacking"; else echo "FAIL: not executable"; exit 1; fi
for f in README-LINUX.txt 60-kg5zzb-rtlsdr.rules LICENSE THIRD-PARTY-NOTICES.txt librnnoise.so; do
  [ -f "$DIR/$f" ] || { echo "FAIL: $f missing from the download"; exit 1; }
done
echo "OK: README, dongle rules file, licences and noise filter are in the download"
grep -q '0bda' "$DIR/60-kg5zzb-rtlsdr.rules" && echo "OK: rules file covers RTL-SDR dongles (0bda)"
if udevadm verify --help >/dev/null 2>&1; then udevadm verify --no-style "$DIR/60-kg5zzb-rtlsdr.rules" && echo "OK: udev accepts the rules file"; fi

# Screen with a window manager, and a sound card whose output we can record.
export DISPLAY=:99
Xvfb :99 -screen 0 1600x1000x24 >/dev/null 2>&1 &
sleep 3
openbox >/dev/null 2>&1 &
pulseaudio -D --exit-idle-time=-1 || true
sleep 2
pactl load-module module-null-sink sink_name=speakers >/dev/null
pactl set-default-sink speakers

N=0
shot() { N=$((N+1)); import -window root "$OUT/$(printf %02d $N)-$1.png"; }
alive() {
  sleep 2; shot "$1"
  if pgrep -f "$DIR/KG5ZZB-SDR-Airband-Receiver" >/dev/null; then echo "OK: app running after: $1"
  else echo "FAIL: app stopped after: $1"; tail -40 "$LOG" 2>/dev/null || true; tail -40 "$OUT"/stdout-*.txt; exit 1; fi
}
ocr() { python3 "$HERE/ocr.py" "$@"; }
titles() { xdotool search --onlyvisible --name . getwindowname %@ 2>/dev/null || true; }
record() { timeout "$1" parec -d speakers.monitor --format=s16le --rate=48000 --channels=1 > "$OUT/$2.raw" || true; }
start() { "$APP" > "$OUT/stdout-$1.txt" 2>&1 & sleep 15; }
quit() {
  pkill -TERM -f "$DIR/KG5ZZB-SDR-Airband-Receiver" || true
  for _ in $(seq 20); do
    pgrep -f "$DIR/KG5ZZB-SDR-Airband-Receiver" >/dev/null || { echo "OK: app closed"; return 0; }
    sleep 1
  done
  echo "FAIL: app did not close"; exit 1
}

echo "== 1. First start: asks where you are"
start first
alive first-start
ocr has "Where are you listening from"
ocr tap --last --below 44 "Where are you listening from"
xdotool type --delay 100 Chicago
sleep 5; shot typed-city
ocr tap --last "Chicago"
sleep 3; shot city-picked
ocr tap "Start listening"
sleep 10
alive main-window
ocr has "Try the demo"

echo "== 2. Free trial: all features for 30 days"
titles | tee "$OUT/window-titles.txt"
if grep -q "30 days left" "$OUT/window-titles.txt"; then echo "OK: window title shows the 30-day trial (this is the trial edition)"
else echo "FAIL: no '30 days left' in the window title"; exit 1; fi

echo "== 3. Test sound comes out of the speakers"
record 9 test-sound & REC=$!
sleep 1; ocr tap "Test sound"
wait $REC || true
python3 "$HERE/peak.py" "$OUT/test-sound.raw" 0.05

echo "== 4. Demo: radio voices come out of the speakers"
ocr tap "Try the demo"
record 45 demo-sound
alive demo-listen
python3 "$HERE/peak.py" "$OUT/demo-sound.raw" 0.05

echo "== 5. Every screen"
# The screen buttons are icons left of "Stop demo": headphones = listen, plane = map, envelope = messages.
listen_btn() { ocr tap --dx -230 "Stop demo"; }
map_btn() { ocr tap --dx -180 "Stop demo"; }
messages_btn() { ocr tap --dx -131 "Stop demo"; }
map_btn; sleep 15; alive map
messages_btn; sleep 30; alive messages
ocr absent "in the full version"
listen_btn; sleep 8; alive listen-again
ocr has "HOLD"
quit

echo "== 6. Second start: remembers the city, no questions"
start second
alive second-start
ocr absent "Where are you listening from"
quit

echo "== 7. After the 30 days: free basic version still opens and plays"
export KG5ZZB_FORCE_BASIC=1
start basic
alive basic-start
titles | tee "$OUT/window-titles-basic.txt"
if grep -q "Free basic version" "$OUT/window-titles-basic.txt"; then echo "OK: title shows the free basic version"; fi
ocr tap "Try the demo"
record 30 basic-demo-sound
alive basic-demo
python3 "$HERE/peak.py" "$OUT/basic-demo-sound.raw" 0.05
messages_btn; sleep 15; alive basic-messages
ocr has "in the full version"
quit
unset KG5ZZB_FORCE_BASIC

echo "== 8. App log"
cp "$LOG" "$OUT/log.txt"
if grep -n -i -E "unhandled|library is missing|RNNoise library not found|fatal" "$LOG"; then echo "FAIL: errors in the log"; exit 1; fi
echo "OK: no errors in the log"
rm -f "$OUT"/*.raw
echo "ALL CHECKS PASSED on $(grep PRETTY_NAME /etc/os-release | cut -d= -f2)"
