"""Reads the screen with OCR (tesseract) and clicks or checks text, the way a person would.

  ocr.py tap [--last] [--word N] [--below PX] "text"
                                          click the text (--last: the lowest match on screen;
                                          --word N: the Nth word of the text, from 1;
                                          --below PX: that many pixels below the text)
  ocr.py has "text" ...                   fail unless every text is on screen
  ocr.py absent "text" ...                fail if any text is on screen
"""
import re, subprocess, sys, time


def norm(s):
    return re.sub(r"[^a-z0-9]", "", s.lower())


def read_screen():
    subprocess.run(["import", "-window", "root", "/tmp/ocr.png"], check=True)
    lines = []
    for extra in ([], ["-negate"]):  # light text on dark buttons reads better inverted
        subprocess.run(["convert", "/tmp/ocr.png", "-colorspace", "Gray", *extra, "-resize", "200%", "/tmp/ocr2.png"], check=True)
        tsv = subprocess.run(["tesseract", "/tmp/ocr2.png", "-", "--psm", "11", "tsv"],
                             capture_output=True, text=True).stdout
        tsv += subprocess.run(["tesseract", "/tmp/ocr2.png", "-", "--psm", "3", "tsv"],
                              capture_output=True, text=True).stdout
        cur, key = [], None
        for row in tsv.splitlines():
            f = row.split("\t")
            if len(f) < 12 or f[0] == "level" or not f[11].strip():
                continue
            k = (f[1], f[2], f[3], f[4])  # page/block/paragraph/line
            if k != key and cur:
                lines.append(cur)
                cur = []
            key = k
            x, y, w, h = (int(v) // 2 for v in f[6:10])
            cur.append((f[11], x, y, w, h))
        if cur:
            lines.append(cur)
    return lines


def find(lines, text):
    want = [norm(w) for w in text.split() if norm(w)]
    hits = []
    for words in lines:
        got = [norm(w[0]) for w in words]
        for i in range(len(got) - len(want) + 1):
            if all(want[j] and (want[j] in got[i + j] if len(want[j]) > 3 else want[j] == got[i + j])
                   for j in range(len(want))):
                hits.append(words[i:i + len(want)])
    return hits


def dump(lines):
    print("Screen text:", " | ".join(" ".join(w[0] for w in l) for l in lines))


def main():
    args = sys.argv[1:]
    cmd = args.pop(0)
    last, word, below = False, None, 0
    while args and args[0].startswith("--"):
        if args[0] == "--last":
            last = True; args.pop(0)
        elif args[0] == "--word":
            word = int(args[1]); del args[:2]
        elif args[0] == "--below":
            below = int(args[1]); del args[:2]
    for attempt in range(3):
        lines = read_screen()
        if cmd == "tap":
            hits = find(lines, args[0])
            if hits:
                hit = max(hits, key=lambda h: h[0][2]) if last else hits[0]
                if word:
                    hit = hit[word - 1:word]
                x0 = min(w[1] for w in hit); x1 = max(w[1] + w[3] for w in hit)
                y0 = min(w[2] for w in hit); y1 = max(w[2] + w[4] for w in hit)
                x, y = (x0 + x1) // 2, (y0 + y1) // 2 + below
                subprocess.run(["xdotool", "mousemove", str(x), str(y), "click", "1"], check=True)
                print(f"clicked '{args[0]}' at {x},{y}")
                return 0
        elif cmd == "has":
            missing = [t for t in args if not find(lines, t)]
            if not missing:
                print("OK, on screen:", ", ".join(args))
                return 0
        elif cmd == "absent":
            shown = [t for t in args if find(lines, t)]
            if shown:
                dump(lines)
                print("FAIL, shown:", ", ".join(shown))
                return 1
            print("OK, not shown:", ", ".join(args))
            return 0
        time.sleep(3)
    dump(lines)
    print(f"FAIL: not found on screen: {args}")
    return 1


sys.exit(main())
