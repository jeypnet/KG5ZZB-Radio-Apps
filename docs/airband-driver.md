# Airband Receiver: our own dongle driver

The **driver** is the part of an app that talks to your USB dongle: it tells the dongle which frequency to listen to and brings the radio signal into the app.

Up to version 0.7, the Airband Receiver used the free driver that most RTL-SDR apps use. **From version 0.8.0 it has its own driver, written for this app.** Here is what that changes for you, measured on the same dongle and the same PC.

## At a glance

| | Free driver | **Our driver** | What it means for you |
|---|:---:|:---:|---|
| ⚡ **Scanner speed** (one round over 49 channels) | 0.7 s | ✅ **0.4 s** | It checks every channel almost **twice as often**, so you catch more of each transmission from the first word. |
| 🧹 **Clean switch between channels** | 38 ms of leftover sound from the last channel | ✅ **none** | The scanner never stops on a channel because of the one before it. |
| 🛡 **Reliability** | — | ✅ **1000 channel and volume changes in a row, 0 errors** | No freezes or failed changes while you listen. |
| ✈ **Planes received** (same dongle, same sky) | 340 messages | ✅ **642 messages** | More plane updates on the map. *(In a shorter test both were equal.)* |
| 🪶 **Lighter on your PC** | 3 programs, about 200 MB | ✅ **1 program, about 170 MB** | Less memory, fewer things running. |
| 📦 **Files in the download** | 5 driver files | ✅ **1 file** | Simpler to unzip and keep together. |
| 📶 **Signal delivered** (5 minutes) | 99.99% | 99.99% | The same: nothing is lost with either. |

## Why it's faster, in plain words

- **It only says what changed.** To move to a new channel, the free driver repeats every setting to the dongle each time. Ours only sends the one thing that changes, the frequency. Less talking, quicker switch.
- **It doesn't wait longer than needed.** After a channel change the dongle needs a moment to settle. The free driver waits a fixed time to be safe. Ours checks again and again and goes on the moment the dongle is ready.
- **It double-checks every command.** If the dongle misses an instruction while it's busy, our driver notices and simply sends it again, so a change never gets lost.
- **No middleman.** The free driver runs as a separate program that passes the signal over to the app. Ours is part of the app, so nothing sits in between.

## Which dongles work

✅ **Almost every RTL-SDR sold today:** dongles with a Rafael **R820T, R820T2, R828D or R860** tuner chip, for example the Nooelec NESDR SMArt, NESDR Mini 2+ and Nano 3, and the RTL-SDR Blog V3 and V4.

❌ **Not supported:** very old dongles with an E4000, FC0012, FC0013 or FC2580 tuner (for example the NESDR XTR).

## About the numbers

- **Plane counts depend on what's flying.** To make it fair, the two drivers took turns every 10 seconds on the same dongle. Over 20 turns ours received almost twice as many messages; in a shorter test of 8 turns they were equal.
- **Speed also depends on your PC's USB port.** The same dongle switched channels in 26 ms on one of the PC's USB ports and 48 ms on another. The scanner speed above (0.4 s) is from the slower port; on the faster one it was 0.2 s.
- **Test setup:** Nooelec NESDR SMArt v5 dongle, Windows 11, both drivers on the same dongle and PC. Free driver: the official osmocom rtl-sdr build (rtl_tcp), as used by Airband Receiver 0.7.

## Licence

Our driver is based on [webrtlsdr](https://github.com/jtarrio/webrtlsdr) (Apache-2.0) plus our own code. The free driver is osmocom rtl-sdr (GNU GPL v2), used by Airband Receiver 0.7.x only.

[⬅ Back to KG5ZZB Radio Apps](../README.md)
