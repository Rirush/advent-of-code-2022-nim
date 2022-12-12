import sequtils, strutils

var
    p: seq[seq[int]]
    startingCoordinates, endingCoordinates: (int, int)

proc makeLengthGraph(p: seq[seq[int]]): seq[seq[int]] =
    for i in 0..<p.len():
        result.add(newSeq[int](p[0].len()))

proc `+`(a, b: (int, int)): (int, int) =
    (a[0] + b[0], a[1] + b[1])

proc dijkstra(p: seq[seq[int]], s, e: (int, int)): int =
    var 
        queue: seq[((int, int), (int, int))]
        lenGraph = makeLengthGraph(p)
    
    for m in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
        let ns = s + m
        if ns[0] < 0 or ns[0] >= p.len() or ns[1] < 0 or ns[1] >= p[0].len():
            continue
        
        if p[ns[0]][ns[1]] - p[s[0]][s[1]] > 1:
            continue

        queue.add((s, ns))

    while queue.len() != 0:
        let (s, ns) = queue[0]
        queue.delete(0)

        let prev = lenGraph[s[0]][s[1]]
        if prev + 1 < lenGraph[ns[0]][ns[1]] or lenGraph[ns[0]][ns[1]] == 0:
            lenGraph[ns[0]][ns[1]] = prev + 1
        else:
            continue

        for m in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            let s = ns
            let ns = s + m
            if ns[0] < 0 or ns[0] >= p.len() or ns[1] < 0 or ns[1] >= p[0].len():
                continue
            
            if p[ns[0]][ns[1]] - p[s[0]][s[1]] > 1:
                continue

            if prev + 1 >= lenGraph[ns[0]][ns[1]] and lenGraph[ns[0]][ns[1]] != 0:
                continue

            queue.add((s, ns))

    return lenGraph[e[0]][e[1]]

proc charToHeight(c: char): int =
    if c in 'a'..'z':
        return ord(c) - ord('a')
    elif c == 'S':
        return 0
    else:
        return 25

while true:
    try:
        let l = stdin.readLine()
        p.add(l.map(charToHeight))
        if 'S' in l:
            startingCoordinates = (p.len()-1, l.find('S'))
        if 'E' in l:
            endingCoordinates = (p.len()-1, l.find('E'))
    except EOFError:
        break

# Part 1
echo dijkstra(p, startingCoordinates, endingCoordinates)

# Part 2
var result = 10000000
for i in 0..<p.len():
    for j in 0..<p[0].len():
        if p[i][j] == 0:
            let r = dijkstra(p, (i, j), endingCoordinates)
            if r != 0:
                result = min(result, r)

echo result