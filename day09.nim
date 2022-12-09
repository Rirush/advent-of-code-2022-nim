import std/[strutils, sets, tables]

let moves = {'R': (0, 1), 'L': (0, -1), 'U': (1, 0), 'D': (-1, 0)}.toTable

var
    rope = initHashSet[(int, int)]()
    hpos = (0, 0)
    tpos = (0, 0)

    tspos = [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]
    lrope = initHashSet[(int, int)]()

while true:
    try:
        let l = stdin.readLine()
        let s = l.split(" ", 2)
        let d = s[0][0]
        let c = s[1].parseInt

        let delta = moves[d]
        for i in 0..<c:
            hpos[0] += delta[0]
            hpos[1] += delta[1]

            if abs(tpos[0] - hpos[0]) > 1 or abs(tpos[1] - hpos[1]) > 1:
                tpos[0] += cmp(hpos[0], tpos[0])
                tpos[1] += cmp(hpos[1], tpos[1])

            if abs(tspos[0][0] - hpos[0]) > 1 or abs(tspos[0][1] - hpos[1]) > 1:
                tspos[0][0] += cmp(hpos[0], tspos[0][0])
                tspos[0][1] += cmp(hpos[1], tspos[0][1])

            for j in 1..8:
                if abs(tspos[j-1][0] - tspos[j][0]) > 1 or abs(tspos[j-1][1] - tspos[j][1]) > 1:
                    tspos[j][0] += cmp(tspos[j-1][0], tspos[j][0])
                    tspos[j][1] += cmp(tspos[j-1][1], tspos[j][1])

            rope.incl(tpos)
            lrope.incl(tspos[8])

    except EOFError:
        break

# Part 1
echo rope.len()

# Part 2
echo lrope.len()