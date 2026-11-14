# KG5ZZB Radio Apps

[![Latest release](https://img.shields.io/github/v/release/jeypnet/KG5ZZB-Radio-Apps?label=download&color=0369A1)](https://github.com/jeypnet/KG5ZZB-Radio-Apps/releases/latest)
![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D4?logo=windows&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-test%20version-555?logo=apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-test%20version-555?logo=linux&logoColor=white)
[![Support on Ko-fi](https://img.shields.io/badge/Support-Ko--fi-FF5E5B?logo=ko-fi&logoColor=white)](https://ko-fi.com/kg5zzb)

**Radio receivers for an inexpensive RTL-SDR USB dongle.** Each one is its own app: download it, plug in the dongle, and listen. Everything runs offline and comes from your own antenna and receiver; no websites or online feeds stand in for it.

**[⬇ Download the latest versions](https://github.com/jeypnet/KG5ZZB-Radio-Apps/releases/latest)**: Windows (one `.exe`, nothing to install), plus test versions for Mac and Linux.

---

## ✈ KG5ZZB SDR Airband Receiver

**Hear pilots and air traffic control, see the planes around you on a map, and read the messages they send.** Free 30-day trial: [download 0.7.2 for Windows](https://github.com/jeypnet/KG5ZZB-Radio-Apps/releases/tag/airband-v0.7.2-trial).

![Listening to the airband, with the AI noise filter on](docs/images/listen.png)

- **🎙 AI noise filter, one button.** A neural network removes hiss and static, quiet pilots come up to the same loudness as the tower, and a limiter keeps it from crackling. Measured with speech recognition counting the words it understood:

  | Signal | Filter off | **Filter on** |
  |---|---|---|
  | Weak | 11% of words | **37%: more than 3× as many** |
  | Medium | 37% | **46%** |
  | Strong | 41% | 41% |

- **🔧 One-click dongle setup.** A brand-new dongle needs a special USB driver; the app installs it with one click and one Windows prompt, then starts by itself.
- **📻 A real scanner, made simple.** SCAN, HOLD, SKIP, MONITOR and DELAY work like a handheld scanner. Every airport channel within 50 miles of your city is found for you, worldwide (about 11,000 airports in 236 countries, built in).
- **✈ Planes on a map.** The app's own ADS-B decoder shows each flight in words ("United 1452"), its airline, the kind of aircraft (airliner, cargo, private jet, helicopter, military), altitude and speed on an offline map. Tick planes to follow them with a dotted path. Click an airport to hear its tower.
- **✉ Their messages, in plain English.** ACARS and VDL Mode 2 messages from airliners and business jets: take-off and landing times, positions, airport weather, engine readings, each explained in a sentence.
- **📻 RTL-SDR, SDRplay and Airspy.** RTL-SDR dongles, plus SDRplay RSP1A/1B/2/duo/dx and Airspy R2/Mini (beta).
- **⚙ Optimize.** It tests every gain setting with your antenna and keeps the best one.
- **▶ Try it without a dongle.** The built-in demo plays realistic radio conversations on your local channels and shows planes and their messages around your city.
- **💻 Windows, Mac and Linux.**

![Planes around Chicago in demo mode](docs/images/planes.png)

## 📻 KG5ZZB Shortwave Receiver (coming soon)

**Worldwide shortwave (HF, 2–26 MHz) with the same dongle**: broadcasts from around the world, weather charts, ship warnings, time stations and the famous spy and mystery stations. Pick your country once; everything else is automatic.

### 🎙 VOICE: broadcasts that are on the air *now*
- A built-in **worldwide schedule** (about 7,900 shortwave broadcasts) plus the **DRM** digital schedule. The scanner only visits what is on the air at this minute, on bands that are open at this hour where you are; no time is wasted on empty frequencies.
- Broadcasts aimed at your part of the world come first; the big international stations are listed wherever they can be heard.
- **SCAN on/off**, ◀◀ ▶▶, MONITOR, squelch, and a stay time per station. It learns what you actually hear at your location.

### 🔇 Noise filters: clear audio from a noisy band
Shortwave is full of hiss, whistles, buzz and clicks, and a desktop PC next to the antenna adds its own. The receiver attacks each of them separately, **on your PC, offline, in real time**:

| Filter | What it removes | How |
|---|---|---|
| **Voice only (AI)** | The background hiss, almost completely | A neural network trained to keep speech (DeepFilterNet3), running inside the app with automatic level make-up. Hiss down more than 20 dB with the voice kept. |
| **Clear voice** | Hiss between and under the words, while keeping music | MMSE log-spectral-amplitude estimation with minimum-statistics noise tracking, the classic method of professional radio software. |
| **Whistle & buzz killer** | Heterodyne whistles and the 60/120 Hz buzz of power supplies, with its harmonics | Finds tones that never change and cuts them 30 dB, with 23 Hz precision so music between the buzz harmonics stays. |
| **Noise blanker** | Clicks and crackle from computers, USB cables, LED drivers, dimmers and chargers | Blanks microsecond spikes in the raw radio signal before they can turn into clicks. |
| **Interference map** | Fixed carriers from nearby electronics that look like stations | Learns carriers that carry no programme where nothing is scheduled, remembers them, and the scanner skips them. |
| **Synchronous AM** | Fading distortion, and a whistle or neighbour station on one side of the signal | Locks onto the station's carrier and, when one sideband has interference, listens to the other, cleaner one. |
| **Smooth switching** | The burst of noise when changing station | A short settle time and a soft fade-in on every change. |

### 📟 DATA: decoded on screen
- **Weather fax:** weather maps drawn line by line, lined up automatically, saved as pictures.
- **RTTY** weather text and **NAVTEX** ship warnings, with error correction.
- **🕒 Time stations** and **🕵 spy and mystery stations** (number stations, The Buzzer, The Squeaky Wheel…) to listen to.
- **FIND** tunes to the station coming in best right now; ▶▶ goes to the next one.

---

## Hardware
- An RTL-SDR dongle with an R820T/R820T2/R860 tuner (for example a Nooelec NESDR SMArt v5 or an RTL-SDR Blog V3/V4).
- An antenna for the band: a simple dipole for the airband, a 1090 MHz antenna for planes, a long wire for shortwave.

## Support
The apps are free. If you enjoy them, you can support them on **[Ko-fi](https://ko-fi.com/kg5zzb)**.

## License
The apps are free to download and use. The source code is not public. See [LICENSE.txt](LICENSE.txt) and [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) for the open-source components they include.

*73 de KG5ZZB*
