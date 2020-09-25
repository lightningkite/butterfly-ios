import Foundation

public extension TimeZone {
    var id: String {
        return identifier
    }

    var displayName: String {
        return description
    }

    func getOffset(date: Int64) -> Int {
        return getOffset(date)
    }

    static func getDefault() -> TimeZone {
        return TimeZone.autoupdatingCurrent
    }
}
