import sequtils, strutils, algorithm

var
    max = [0, 0, 0]
    cumulative = 0
    running = true

while running:
    var line = ""
    running = stdin.readLine(line)

    if line == "":
        for i in 0..2:
            if cumulative > max[i]:
                max[i] = cumulative
                break
        max.sort()
        cumulative = 0
    else:
        cumulative += line.parseInt()

echo "Part 1: ", max[2]
echo "Part 2: ", max.foldl(a + b)
