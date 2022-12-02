import strutils, tables

type
    Action = enum
        Rock = 1
        Paper
        Scissors

func next(a: Action): Action =
    if a == Scissors: Rock else: Action(ord(a) + 1)

func prev(a: Action): Action =
    if a == Rock: Scissors else: Action(ord(a) - 1)

func intoAction(s: string): Action =
    case s:
        of "A": Rock
        of "B": Paper
        of "C": Scissors
        else: raise newException(ValueError, s & " is not a valid value")

func intoPlaceholder(s: string): uint8 =
    case s:
        of "X": 0
        of "Y": 1
        of "Z": 2
        else: raise newException(ValueError, s & " is not a valida value")

proc score(a, b: Action): int =
    result += ord(b)
    if a == b: result += 3
    elif b == a.next(): result += 6

var 
    counter = newCountTable[(Action, uint8)](0)

while true:
    try:
        var a, b: string
        (a, b) = stdin.readLine().split(' ', 2)
        counter.inc((a.intoAction, b.intoPlaceholder))
    except EOFError:
        break

# Part 1
var firstSum = 0
for k in counter.keys:
    firstSum += score(k[0], Action(k[1]+1)) * counter[k]

# Part 2
var sum = 0
for k in counter.keys:
    if k[1] == 0:
        sum += score(k[0], k[0].prev) * counter[k]
    if k[1] == 1:
        sum += score(k[0], k[0]) * counter[k]
    if k[1] == 2:
        sum += score(k[0], k[0].next) * counter[k]

echo "Part 1: ", firstSum
echo "Part 2: ", sum
