import strutils, sequtils

proc isVisible(x, y: int, forest: seq[seq[int]]): bool =
    let l = forest[x][y]
    if x == 0 or y == 0 or x == forest.len()-1 or y == forest[x].len()-1:
        return true

    var v = true
    for x1 in countdown(x-1, 0):
        if forest[x1][y] >= l:
            v = false
            break
    if v:
        return true

    v = true
    for x1 in x+1..<forest.len():
        if forest[x1][y] >= l:
            v = false
            break
    if v:
        return true

    v = true
    for y1 in countdown(y-1, 0):
        if forest[x][y1] >= l:
            v = false
            break
    if v:
        return true

    v = true
    for y1 in y+1..<forest[x].len():
        if forest[x][y1] >= l:
            v = false
            break
    
    return v

proc scenicScore(x, y: int, forest: seq[seq[int]]): int =
    let l = forest[x][y]
    var c = [0, 0, 0, 0]

    for x1 in countdown(x-1, 0):
        c[0] += 1
        if forest[x1][y] >= l:
            break

    for x1 in x+1..<forest.len():
        c[1] += 1
        if forest[x1][y] >= l:
            break

    for y1 in countdown(y-1, 0):
        c[2] += 1
        if forest[x][y1] >= l:
            break


    for y1 in y+1..<forest[x].len():
        c[3] += 1
        if forest[x][y1] >= l:
            break

    return foldl(c, a * b)
    

proc parseInt(c: char): int =
    return ord(c) - ord('0')

var forest: seq[seq[int]] = @[]

while true:
    try:
        let l = stdin.readLine()
        forest.add(l.map(parseInt))
    except EOFError:
        break

var 
    r = 0
    score = 0
for x in 0..<forest.len():
    for y in 0..<forest[x].len():
        score = max(score, scenicScore(x, y, forest))
        if isVisible(x, y, forest):
            r += 1

# Part 1
echo r

# Part 2
echo score