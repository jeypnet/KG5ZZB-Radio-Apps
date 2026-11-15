<div align="center">

# ⚡ Our own RTL-SDR driver

**The Airband Receiver doesn't use the standard free driver that most RTL-SDR apps share.**<br>
It talks to your dongle with **its own driver, written for scanning the airband.**

<br>

| ⚡ **Almost 2× faster** | 🧹 **0 ms** | 🛡 **1000 / 1000** | 🪶 **1 program** |
|:---:|:---:|:---:|:---:|
| scanner: one round over 49 channels in **0.4 s** instead of 0.7 s | of leftover sound from the last channel (standard driver: 38 ms) | channel and volume changes in a row, **zero errors** | instead of 3, and about **30 MB less memory** |

✅ **Works with the RTL-SDR Blog V2, V3 and V4**, Nooelec NESDR SMArt, Mini 2+ and Nano 3, and every RTL2832U dongle with an R820T, R820T2, R828D or R860 tuner.

</div>

---

## 🥇 Side by side

Measured on the same dongle and the same PC. "Standard driver" is the free open-source driver most RTL-SDR programs use.

| | Standard free driver | ✅ **Our driver** |
|---|:---:|:---:|
| ⚡ **Scanner speed**, one round over 49 channels | 0.7 s | **0.4 s** (0.2 s on a fast USB port) |
| 🔁 **Channel switch** | repeats every tuner setting | **sends only what changed: 26 ms** |
| 🧹 **Leftover sound after a switch** | 38 ms of the last channel | **none** |
| ⏱ **Waiting for the dongle to settle** | a fixed safety pause | **goes on the moment it's ready** |
| 🛡 **A command the busy dongle missed** | can get lost | **noticed and sent again** |
| 🔗 **How the signal reaches the app** | through a separate helper program | **directly, inside the app** |
| 🪶 **Programs running · memory** | 3 · about 200 MB | **1 · about 170 MB** |
| 📦 **Driver files in the download** | 5 | **1** |
| 📶 **Signal delivered**, 5 minutes nonstop | 99.99% | **99.99%**, nothing lost |

## 🎯 Why it matters on the airband

Pilots and controllers talk in short bursts, often only two or three seconds. A scanner can only stop on a transmission it notices, so **every millisecond spent switching is time it can't listen.**

- **It visits each channel almost twice as often,** so it catches a call sooner and you hear more of the first words.
- **It never stops for the wrong reason.** With the standard driver, the first moment after a switch still carries sound from the channel before. A scanner can mistake that for a transmission. Ours throws that moment away, so a stop always means someone is really talking.
- **It keeps going for hours.** Every command is checked, so a busy USB moment never leaves the scanner stuck on one channel.

## 🧠 How it does it

| What it does | The standard way | Our way |
|---|---|---|
| **Talks less** | Rewrites the tuner's settings on every frequency change | Remembers what the tuner already has and **sends only the change** |
| **Waits less** | Sleeps a fixed time after each change, to be safe | **Asks the tuner whether it's locked** and continues the instant it is |
| **Listens clean** | Passes on the samples recorded during the switch | **Drops the samples from the switch**, so each channel starts clean |
| **Never loses a command** | A command sent while the dongle is busy can fail | **Checks every command** and sends it again when needed |
| **No middleman** | A helper program streams the signal to the app over the network | **The driver is part of the app**; nothing sits in between |
| **Knows your dongle** | One generic setup | **The RTL-SDR Blog V4's own tuner setup** is built in |

## 🔌 Easy from the first minute

| | The usual way | ✅ **Airband Receiver** |
|---|---|---|
| **New dongle on Windows** | Download a separate USB tool and pick the right device by hand | **🔧 Set up dongle**: one click inside the app |
| **Best gain for your antenna** | Try settings by hand and listen | **⚙ Optimize** tests every gain setting and keeps the best one |
| **Two dongles** | Work out which one is which | **Plug and play**: the app finds which dongle hears planes and gives it the map |
| **Windows, macOS, Linux** | A different setup on each system | **The same driver on every system** |

## ✅ Which dongles work

| | Dongles |
|---|---|
| ✅ **Supported** | **RTL-SDR Blog V2 and V3** (R820T2) · **RTL-SDR Blog V4** (R828D) · Nooelec NESDR SMArt v4 / v5 · NESDR Mini 2+ · NESDR Nano 2+ / 3 · any RTL2832U dongle with an **R820T, R820T2, R828D or R860** tuner |
| ❌ **Not supported** | Very old dongles with an E4000, FC0012, FC0013 or FC2580 tuner (for example the NESDR XTR) |

The app also works with **SDRplay** and **Airspy** receivers (beta). See [Compatible receivers](../README.md#-compatible-receivers).

## 📏 How we measured

- **Same dongle, same PC, both drivers:** a Nooelec NESDR SMArt v5 on Windows 11, compared with the official open-source driver build.
- **Scanner speed depends on the USB port.** The same dongle switched channels in 26 ms on one port and 48 ms on another. The 0.4 s round is from the slower port; on the faster one it was 0.2 s.

## 📄 Licence

Our driver is built on [webrtlsdr](https://github.com/jtarrio/webrtlsdr) (Apache-2.0) plus our own code. Details in [THIRD-PARTY-NOTICES.md](../THIRD-PARTY-NOTICES.md).

[⬅ Back to KG5ZZB Radio Apps](../README.md)
