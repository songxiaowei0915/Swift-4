import UIKit

let s = "Hello Mars"
var i = s.firstIndex(of: " ")
//let greeting = s[s.startIndex ..< i!]
var greeting = s.prefix(upTo: i!)

i = s.index(i!, offsetBy: 1)
//let name = s[i! ..< s.endIndex]
let name = s.suffix(from: i!)

print(greeting)
print(name)

print(Array(s.enumerated()))
print(Array(zip(1..., s)))


greeting = "Hello Mars"
greeting.count
greeting.forEach {
    print($0)
}

let xmlInfo = """
<?xml version="1.0"?>
    <episode id="1">
        <title>String is a collection again</title>
        <author>11</author>
        <created_at>2017-05-18</created_at>
    </episode>
"""

let jsonInfo = """
{
    "episode": {
        "title": "String is a collection again"
        "author": "11"
        "created_at": "2017-05-18"
    }
}
"""

print(xmlInfo)
print(jsonInfo)

class Rboot {
    private var battery = 0.5
}

extension Rboot {
    func charge() {
        battery = 1.0
    }
}

let r = Rboot()

class Foo: NSObject {
    @objc var bar = "bar"
    @objc var baz = [1, 2, 3, 4]
}
var foo = Foo()
print(foo.bar)
foo.bar = "BAR"

var bar = foo.value(forKeyPath: #keyPath(Foo.bar))
print(bar!)
foo.setValue("barp", forKeyPath: #keyPath(Foo.bar))
print(foo.bar)

let barKeyPath = \Foo.bar
bar = foo[keyPath: barKeyPath]
foo[keyPath: barKeyPath] = "Bar"


let numberSet = Set(1 ... 100)
let evens = numberSet.lazy.filter {
    $0 % 2 == 0
}
let evenSet = Set(evens)
evenSet.isSubset(of: numberSet)

let numberDictionary = ["one": 1, "two": 2, "three": 3, "four": 4]
let evenColl = numberDictionary.lazy.filter { $0.1 % 2 == 0}
let evenDictionary = Dictionary(uniqueKeysWithValues: evenColl.map {(key: $0.0, value: $0.1) })
evenDictionary

let numbers = ["one", "two", "three", "four"]
let numberDict = Dictionary(uniqueKeysWithValues: numbers.enumerated().map {($0.1, $0.0+1) })
numberDict

let numberDict2 = Dictionary(uniqueKeysWithValues: zip(numbers, 1...))

let duplicates = [("a",1), ("b",2),("a",3),("b",4)]
let letters = Dictionary(duplicates, uniquingKeysWith: {(first, _) in first })
letters

let names = ["Aaron", "Abe", "Bain", "Bally", "Mars", "Nacci"]
let groupNames = Dictionary(grouping: names, by: { $0.first! })
groupNames

let charactrers = "aaabbbccceee"
var frequencies: [Character: Int] = [:]
charactrers.forEach {
//    if frequencies[$0] != nil {
//        frequencies[$0]! += 1
//    }
//    else {
//        frequencies[$0] = 1
//    }
    frequencies[$0, default: 0] += 1
}
frequencies

let filtered = numberDictionary.filter { $0.value % 2 == 0 }
type(of: filtered)

print(numberDictionary.mapValues { Double($0) })

var numbers2 = [1, 2, 3, 4, 5]

numbers2.swapAt(0, 4)

struct JSON {
    private var data: [String: Any]
    
    init(data: [String: Any]) {
        self.data = data
    }
    
    subscript<T>(key: String) -> T? {
        return data[key] as? T
    }
}

let json = JSON(data: [
    "title": "Generic subscript",
    "duration": 300
])

let title: String? = json["title"]
let duration: Int? = json["duration"]

protocol P { }
struct S : P { }
class C { }
class D : P { }
class E : C, P {}

let u: C & P = E()
