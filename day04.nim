import strutils, sequtils

type ElfRange = object
    l, r: int

func parseRange(s: string): ElfRange =
    (result.l, result.r) = s.split('-', 2).map(parseInt)

func parseRangePair(s: string): (ElfRange, ElfRange) =
    (result[0], result[1]) = s.split(',', 2).map(parseRange)

func fullyOverlaps(r1: ElfRange, r2: ElfRange): bool =
    r1.l >= r2.l and r1.r <= r2.r or r2.l >= r1.l and r2.r <= r1.r

func partiallyOverlaps(r1: ElfRange, r2: ElfRange): bool =
    fullyOverlaps(r1, r2) or r1.r >= r2.l and r1.r <= r2.r or r2.r >= r1.l and r2.r <= r1.r

var
    fullOverlaps = 0
    partialOverlaps = 0

while true:
    try:
        let line = stdin.readLine()
        let (r1, r2) = line.parseRangePair()

        if fullyOverlaps(r1, r2): fullOverlaps += 1
        if partiallyOverlaps(r1, r2): partialOverlaps += 1
    except EOFError:
        break

# Part 1
echo fullOverlaps

# Part 2
echo partialOverlaps
