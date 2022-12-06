import std/setutils

proc nonRepeatingSubstringIndex(str: string, l: int): int =
    for i in l-1..<str.len():
        if str[i-l+1..i].toSet().len() == l:
            return i

let l = stdin.readLine()

# Part 1
echo l.nonRepeatingSubstringIndex(4) + 1

# Part 2
echo l.nonRepeatingSubstringIndex(14) + 1
