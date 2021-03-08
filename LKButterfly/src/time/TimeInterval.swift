//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation


public extension TimeInterval {
    var milliseconds: Int64 {
        return Int64(self * 1000)
    }
}
public extension TimeInterval {
    var seconds: Double {
        return self
    }
}

public extension Int {
    func milliseconds() -> TimeInterval { return TimeInterval(self) / 1000 }
    func seconds() -> TimeInterval { return TimeInterval(self) }
    func minutes() -> TimeInterval { return TimeInterval(self * 60) }
    func hours() -> TimeInterval { return TimeInterval(self * 60 * 60) }
    func days() -> TimeInterval { return TimeInterval(self * 60 * 60 * 24) }
}
