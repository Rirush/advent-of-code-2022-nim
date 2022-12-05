import strutils, sequtils, algorithm

type
    Ship = object
        stacks: seq[seq[char]]

iterator crateIndexes(crates: int): (int, int) =
    for i in 0..<crates:
        yield (i, 1 + (i * 4))

var
    readingInitialState = true
    l = stdin.readLine()
    stacks = (l.len() + 1) div 4
    ship1 = Ship(stacks: newSeq[seq[char]](stacks))
    ship2 = Ship()

for i in 0..<stacks:
    ship1.stacks[i] = newSeq[char]()

for (i, c) in crateIndexes(stacks):
    if l[c] != ' ':
        ship1.stacks[i].add(l[c])

while true:
    try:
        l = stdin.readLine()
        if l == "":
            readingInitialState = false
            for i in 0..<stacks:
                ship1.stacks[i].reverse()

            ship2 = ship1
            continue

        if l[1].isDigit():
            continue

        if readingInitialState:
            for (i, c) in crateIndexes(stacks):
                if l[c] != ' ':
                    ship1.stacks[i].add(l[c])
            continue

        let tokens = l.split(" ")
        assert tokens.len() == 6
        let
            takeAmount = tokens[1].parseInt()
            fromIndex = tokens[3].parseInt() - 1
            toIndex = tokens[5].parseInt() - 1

        for i in 0..<takeAmount:
            ship1.stacks[toIndex].add(ship1.stacks[fromIndex].pop())

        let
            stackLen = ship2.stacks[fromIndex].len()
            moveRange = stackLen-takeAmount..stackLen-1

        ship2.stacks[toIndex].add(ship2.stacks[fromIndex][moveRange])
        ship2.stacks[fromIndex].delete(moveRange)

    except EOFError:
        break

# Part 1
echo foldl(ship1.stacks, a & b[b.len()-1], "")

# Part 2
echo foldl(ship2.stacks, a & b[b.len()-1], "")
