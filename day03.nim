import sets

func value(c: char): int =
    case c
    of 'a'..'z': ord(c) - ord('a') + 1
    of 'A'..'Z': ord(c) - ord('A') + 27
    else: 0

func halves(s: string): (string, string) =
    (s[0..<s.len() div 2], s[s.len() div 2..<s.len()])

func join[T](s: (HashSet[T], HashSet[T])): HashSet[T] = s[0] + s[1]

var inSets = newSeq[(HashSet[char], HashSet[char])]()

while true:
    try:
        let line = stdin.readLine()
        let (firstHalf, secondHalf) = line.halves()
        inSets.add((firstHalf.toHashSet(), secondHalf.toHashSet()))
    except EOFError:
        break

# Part 1
var priority = 0

for pair in inSets:
    var values = intersection(pair[0], pair[1])
    assert values.len == 1
    priority += values.pop().value()

echo priority

# Part 2
priority = 0

for i in 0..<inSets.len() div 3:
    var values = inSets[i*3].join()
    for j in 1..2:
        values = values * inSets[(i*3)+j].join()
    priority += values.pop().value()

echo priority
