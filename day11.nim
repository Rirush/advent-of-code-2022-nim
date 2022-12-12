import strutils, sequtils, algorithm

type
    Operation = enum Multiply, Add
    Operand = enum Constant, Item

    Monkey = object
        items: seq[int]
        operation: Operation
        divisibleBy: int
        passOnTrue: int
        passOnFalse: int
        case lv: Operand
        of Constant:
            leftValue: int
        of Item:
            discard
        case rv: Operand
        of Constant:
            rightValue: int
        of Item:
            discard
        processedItems: int

proc getLeftValue(m: Monkey, i: int): int =
    case m.lv:
    of Constant:
        m.leftValue
    of Item:
        i

proc getRightValue(m: Monkey, i: int): int =
    case m.rv:
    of Constant:
        m.rightValue
    of Item:
        i

proc process(m: Monkey, i: int): int =
    case m.operation:
    of Multiply:
        m.getLeftValue(i) * m.getRightValue(i)
    of Add:
        m.getLeftValue(i) + m.getRightValue(i)

var monkeys: seq[Monkey] = @[]

while true:
    try:
        var l = stdin.readLine()
        l.removePrefix(' ')
        if l.startsWith("Monkey"):
            monkeys.add(Monkey())
        elif l.startsWith("Starting items: "):
            l.removePrefix("Starting items: ")
            monkeys[monkeys.len()-1].items = l.split(", ").map(parseInt)
        elif l.startsWith("Operation: new = "):
            l.removePrefix("Operation: new = ")
            let v = l.split(" ")
            if v[0] == "old":
                monkeys[monkeys.len()-1].lv = Item
            else:
                monkeys[monkeys.len()-1].lv = Constant
                monkeys[monkeys.len()-1].leftValue = v[0].parseInt()
            
            if v[1] == "*":
                monkeys[monkeys.len()-1].operation = Multiply
            else:
                monkeys[monkeys.len()-1].operation = Add

            if v[2] == "old":
                monkeys[monkeys.len()-1].rv = Item
            else:
                monkeys[monkeys.len()-1].rv = Constant
                monkeys[monkeys.len()-1].rightValue = v[2].parseInt()
        elif l.startsWith("Test: divisible by "):
            l.removePrefix("Test: divisible by ")
            monkeys[monkeys.len()-1].divisibleBy = l.parseInt()
        elif l.startsWith("If true: throw to monkey "):
            l.removePrefix("If true: throw to monkey ")
            monkeys[monkeys.len()-1].passOnTrue = l.parseInt()
        elif l.startsWith("If false: throw to monkey "):
            l.removePrefix("If false: throw to monkey ")
            monkeys[monkeys.len()-1].passOnFalse = l.parseInt()
    except EOFError:
        break

var extremeMonkeys = monkeys

for round in 0..<20:
    for mi in 0..<monkeys.len():
        while monkeys[mi].items.len() != 0:
            monkeys[mi].processedItems += 1
            monkeys[mi].items[0] = process(monkeys[mi], monkeys[mi].items[0])
            monkeys[mi].items[0] = monkeys[mi].items[0] div 3
            if monkeys[mi].items[0] mod monkeys[mi].divisibleBy == 0:
                monkeys[monkeys[mi].passOnTrue].items.add(monkeys[mi].items[0])
                monkeys[mi].items.delete(0)
            else:
                monkeys[monkeys[mi].passOnFalse].items.add(monkeys[mi].items[0])
                monkeys[mi].items.delete(0)

let modulus = foldl(extremeMonkeys, a * b.divisibleBy, 1)

for round in 0..<10000:
    for mi in 0..<extremeMonkeys.len():
        while extremeMonkeys[mi].items.len() != 0:
            extremeMonkeys[mi].processedItems += 1
            extremeMonkeys[mi].items[0] = process(extremeMonkeys[mi], extremeMonkeys[mi].items[0]) mod modulus
            if extremeMonkeys[mi].items[0] mod extremeMonkeys[mi].divisibleBy == 0:
                extremeMonkeys[extremeMonkeys[mi].passOnTrue].items.add(extremeMonkeys[mi].items[0])
                extremeMonkeys[mi].items.delete(0)
            else:
                extremeMonkeys[extremeMonkeys[mi].passOnFalse].items.add(extremeMonkeys[mi].items[0])
                extremeMonkeys[mi].items.delete(0)

# Part 1
var items = monkeys.map(proc(m: Monkey): int = m.processedItems)
items.sort(Descending)
echo items[0] * items[1]

# Part 2

items = extremeMonkeys.map(proc(m: Monkey): int = m.processedItems)
items.sort(Descending)
echo items[0] * items[1]
