"""Prints the loudest sample (0 to 1) of a raw 16-bit recording; fails below the minimum given."""
import array, sys
data = open(sys.argv[1], "rb").read()
a = array.array("h", data[: len(data) // 2 * 2])
peak = max((abs(x) for x in a), default=0) / 32768
print(f"{sys.argv[1]}: {len(a) / 48000:.1f} s recorded, peak {peak:.3f} (needs {sys.argv[2]})")
sys.exit(0 if peak >= float(sys.argv[2]) else 1)
