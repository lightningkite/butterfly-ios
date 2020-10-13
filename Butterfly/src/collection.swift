//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation


//--- List<T>.withoutIndex(Int)

public extension Array {

    //--- Iterable<T>.sumByLong((T)->Long)
    func sumByLong(selector: (Element) -> Int64)-> Int64{
        var sum:Int64 = 0
        for item in self {
            sum += selector(item)
        }
        return sum
    }

    //--- MutableList<T>.binaryInsertBy(T, (T)->K?)
    mutating func binaryInsertBy<K: Comparable>(
        item: Element,
        selector: (Element)->K?
    ) {
        let index = binarySearchBy(key: selector(item), selector: selector)
        if index < 0 {
            insert(
                item,
                at: -index - 1
            )
        } else {
            insert(
                item,
                at: index
            )
        }
    }

    //--- MutableList<T>.binaryInsertByDistinct(T, (T)->K?)
    mutating func binaryInsertByDistinct<K: Comparable>(item: Element, selector: (Element) -> K?) -> Bool {
        let index = binarySearchBy(key: selector(item), selector: selector)
            if index < 0 {
                insert(
                    item,
                    at: -index - 1
                )
                return true
            } else {
                return false
            }
    }

    //--- List<T>.binaryFind(K, (T)->K?)
    func binaryFind<K: Comparable>(key: K, selector: (Element) -> K?) -> Element?  {
        let index = binarySearchBy(key: key, selector: selector)
        if index >= 0 {
            return self[index]
        } else {
            return nil
        }
    }

    //--- List<T>.binaryForEach(K, K, (T)->K?, (T)->Unit)
    func binaryForEach<K: Comparable>(lower: K, upper: K, selector: (Element) -> K?, action: (Element) -> Void) -> Void {
        var index = binarySearchBy(key: lower, selector: selector)
        if index < 0 {
            index = -index - 1
        }
        while index < count {
            let item = self[index]
            let itemK = selector(item)
            if let itemK = itemK, itemK > upper { break }
            action(item)
            index += 1
        }
    }
    
    //--- List<T>.binarySearchBy(K?, (T)->K?)
    func binarySearchBy<K: Comparable>(
        key: K?,
        selector: (Element)->K?
    ) -> Int {
        let a = key
        return binarySearchBy(
            comparison: { item in
                guard let a = a else { return .orderedAscending }
                guard let b = selector(item) else { return .orderedDescending }
                return b.compare(to: a)
            }
        )
    }
    
    func binarySearchBy(
        comparison: (Element)->ComparisonResult
    ) -> Int{
        var low = 0
        var high = count - 1
        while low <= high {
            let mid = (low + high) >> 1
            let cmp = comparison(self[mid])
            switch cmp {
            case .orderedAscending:
                low = mid + 1
            case .orderedSame:
                return mid
            case .orderedDescending:
                high = mid - 1
            }
        }
        return -(low + 1)
    }
    
    func asReversed() -> Array<Element>{
        var reversed = self
        forEachIndexed{ index, value in
            reversed[self.count - index - 1] = value
        }
        return reversed
    }
}

fileprivate extension Comparable {
    func compare(to other: Self) -> ComparisonResult {
        if self < other {
            return .orderedAscending
        } else if self > other {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
}
