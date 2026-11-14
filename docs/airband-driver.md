# Airband Receiver: our own RTL-SDR driver

From version **0.8.0** the Airband Receiver talks to RTL-SDR dongles with its own driver, written for this app, instead of the free osmocom rtl-sdr driver (`rtl_tcp`) used up to 0.7.x. Here is how the two compare, measured on the same dongle and PC.

**Test setup:** Nooelec NESDR SMArt v5 (RTL2832U + R820T2), Windows 11, 2.4 MS/s, two dongles plugged straight into the PC. "Free driver" is the official osmocom Windows build (rtl_tcp, 2026-10-18), run the way Airband Receiver 0.7.x ran it.

| | Free driver (osmocom rtl_tcp) | **Our driver (0.8.0)** |
|---|---|---|
| Data from the old frequency after a retune | 38 ms, every time (it must be thrown away before listening) | **0 ms** in 80 retunes: the driver returns once the tuner has locked |
| Time for one retune | the command returns at once, the data follows 38 ms later | **26 ms** until locked and listening (48 ms on the PC's slower USB controller) |
| Scanner: one pass over 49 airband channels | 0.7 s | **0.4 s** (0.2 s on the faster USB controller) |
| Retunes and gain changes while streaming | — | **1000 in a row, 0 errors** |
| Samples delivered over 5 minutes at 2.4 MS/s | 99.985% | 99.988% |
| Plane messages (ADS-B), drivers alternated every 10 s on the same dongle | 340 in 20 rounds · 50 in 8 rounds | **642** in 20 rounds · 50 in 8 rounds |
| Memory, app scanning with two dongles | 189–216 MB in 3 processes | **165–176 MB in 1 process** |
| CPU (12-core PC) | 0.7% | 0.8–0.9% (the scanner makes about 3× as many steps per second) |
| Files shipped for the dongle | rtl_tcp.exe, rtl_eeprom.exe, librtlsdr.dll, libusb-1.0.dll, libwinpthread-1.dll | **libusb-1.0.dll** |
| Licence of the driver | GNU GPL v2 or later | Apache-2.0 (ported from [webrtlsdr](https://github.com/jtarrio/webrtlsdr)) + our own code |

**What changed in the driver to get there:**
- A retune only sends the tuner registers that actually change. Within the airband that is just the frequency synthesizer, so fewer USB round trips per step.
- The tuner's lock is checked as soon as it is ready, instead of sleeping in fixed 5–15 ms steps.
- Every command is checked and retried if the dongle rejects it while streaming, so retunes and gain changes don't fail.
- One process, no local network connection in between.

**Tuners supported:** Rafael R820T, R820T2, R828D and R860, found in nearly every RTL-SDR sold today (for example RTL-SDR Blog V3 and V4, Nooelec NESDR SMArt). Very old dongles with E4000, FC0012, FC0013 or FC2580 tuners work with the free driver but not with ours.

**Notes on the numbers:** the plane counts depend on what flies by, which is why the two drivers took turns every 10 seconds on the same dongle; in the shorter 8-round test they were equal. Retune times depend on the USB controller: the same dongle took 26 ms on one of the PC's USB controllers and 48 ms on the other.
