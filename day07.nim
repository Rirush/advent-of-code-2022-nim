import tables, strutils

type 
    File = object
        name: string
        size: uint

    Directory {.acyclic.} = ref object
        files: seq[File]
        s: TableRef[string, Directory]

proc newDirectory(): Directory =
    Directory(files: @[], s: newTable[string, Directory]())

proc directorySize(d: Directory): uint =
    var totalSize = 0'u
    for f in d.files:
        totalSize += f.size
    for dir in d.s.values():
        totalSize += directorySize(dir)
    return totalSize

var root = newDirectory()
var directories = newTable[string, Directory]()
directories["/"] = root
var currentPath: seq[string] = @[]
var d: Directory = root

while true:
    try:
        let l = stdin.readLine()
        if l[0] == '$':
            let sp = l.split(' ', 3)
            if sp[1] == "cd":
                if sp[2] == "/":
                    currentPath = @[]
                elif sp[2] == "..":
                    discard currentPath.pop()
                else:
                    currentPath.add(sp[2])
                
                d = root
                for el in currentPath:
                    if not d.s.hasKey(el):
                        d.s[el] = newDirectory()
                        directories["/"&currentPath.join("/")] = d.s[el]
                    d = d.s[el]
        else:
            let sp = l.split(' ', 2)
            if sp[0] != "dir":
                let size = sp[0].parseUInt
                let name = sp[1]
                d.files.add(File(name: name, size: size))

    except EOFError:
        break

# Part 1
var total = 0'u
for d in directories.keys():
    let ds = directorySize(directories[d])
    if ds <= 100000:
        total += ds

echo total

# Part 2
let rootSize = directorySize(root)
let neededSpace = 30000000 - (70000000 - rootSize)
var size = rootSize
for d in directories.keys():
    let ds = directorySize(directories[d])
    if ds >= neededSpace:
        size = min(size, ds)

echo size
