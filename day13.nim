import json, algorithm

var 
    vi = 1
    r = 0

type R = enum Left, Right, Equal

proc compare(a, b: JsonNode): R =
    for i in 0..<a.len():
        if i >= b.len():
            return Right

        if a[i].kind == JInt and b[i].kind == JInt:
            if a[i].getInt() < b[i].getInt():
                return Left
            elif a[i].getInt() > b[i].getInt():
                return Right

        if a[i].kind == JArray and b[i].kind == JArray:
            let r = compare(a[i], b[i])
            if r != Equal:
                return r

        if a[i].kind == JArray and b[i].kind == JInt:
            let r = compare(a[i], JsonNode(kind: JArray, elems: @[b[i]]))
            if r != Equal:
                return r

        if a[i].kind == JInt and b[i].kind == JArray:
            let r = compare(JsonNode(kind: JArray, elems: @[a[i]]), b[i])
            if r != Equal:
                return r

    if a.len() == b.len():
        return Equal
    else:
        return Left

var values: seq[JsonNode] = @[]

while true:
    try:
        let 
            l1 = stdin.readLine()
            l2 = stdin.readLine()

        let v1 = l1.parseJson()
        let v2 = l2.parseJson()

        values.add(v1)
        values.add(v2)

        let res = compare(v1, v2)
        if res == Left:
            r += vi

        vi += 1

        discard stdin.readLine()
    except EOFError:
        break

# Part 1
echo r

# Part 2
values.add(%[[2]])
values.add(%[[6]])
values.sort(proc (a, b: JsonNode): int = 
    case compare(a, b)
    of Left: -1
    of Equal: 0
    of Right: 1)

echo (values.find(%[[2]]) + 1) * (values.find(%[[6]]) + 1)
