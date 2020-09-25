import Foundation

public extension TimeZone {
    var id: String {
        return identifier
    }

    var displayName: String {
        return description
    }

    func getOffset(date: Int64) -> Int {
        return self.secondsFromGMT(for: Date(date)) * 1000
    }

    static func getDefault() -> TimeZone {
        return TimeZone.autoupdatingCurrent
    }
}
