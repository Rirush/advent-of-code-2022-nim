import strutils

let signalCycles = {20, 60, 100, 140, 180, 220}

var 
    cycle = 0
    x = 1
    signal = 0
    buffer = ""

while true:
    try:
        let l = stdin.readLine()
        let op = l.split(" ")
        if op[0] == "noop":
            cycle += 1
            if cycle in signalCycles:
                signal += cycle * x
            
            if abs((cycle - 1) mod 40 - x) <= 1:
                buffer.add("#")
            else:
                buffer.add(".")
            
            if (cycle - 1) mod 40 == 39:
                buffer.add("\n")

        elif op[0] == "addx":
            let d = op[1].parseInt()
            cycle += 2
            if cycle in signalCycles:
                signal += cycle * x
            elif cycle - 1 in signalCycles:
                signal += (cycle - 1) * x

            if abs((cycle - 2) mod 40 - x) <= 1:
                buffer.add("#")
            else:
                buffer.add(".")

            if (cycle - 2) mod 40 == 39:
                buffer.add("\n")

            if abs((cycle - 1) mod 40 - x) <= 1:
                buffer.add("#")
            else:
                buffer.add(".")
            
            if (cycle - 1) mod 40 == 39:
                buffer.add("\n")

            x += d

    except EOFError:
        break

# Part 1
echo signal

# Part 2
echo buffer