import Foundation

public func dictionaryOf<A, B>(_ contents: Pair<A, B>...) -> Dictionary<A, B> {
    return Dictionary(contents.map { $0.toTuple() }, uniquingKeysWith: { (_, a) in a })
}
public func dictionaryFrom<A, B>(_ contents: Array<Pair<A, B>>) -> Dictionary<A, B> {
    return Dictionary(contents.map { $0.toTuple() }, uniquingKeysWith: { (_, a) in a })
}
public extension Dictionary {

    mutating func putAll(from: Dictionary<Key, Value>) {
        for (key, value) in from {
            self[key] = value
        }
    }

    static func +(lhs: Self, rhs: Self) -> Self {
        var copy = lhs
        copy.putAll(from: rhs)
        return copy
    }

    func plus(map: Self) -> Self {
        var copy = self
        copy.putAll(from: map)
        return copy
    }

    mutating func getOrPut(key: Key, defaultValue: ()->Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            let newValue = defaultValue()
            self[key] = newValue
            return newValue
        }
    }

    func minus(key:Key) -> Dictionary {
        var temp = self
        temp.removeValue(forKey: key)
        return temp
    }
}