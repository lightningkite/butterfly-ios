// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: time/TimeAlone.ext.kt
// Package: com.lightningkite.butterfly.time
import Foundation

public extension TimeAlone {
    func normalize() -> Void {
        self.hour = (self.hour + self.minute.floorDiv(other: 60)).floorMod(other: 24)
        self.minute = (self.minute + self.second.floorDiv(other: 60)).floorMod(other: 60)
        self.second = self.second.floorMod(other: 60)
    }
}

public extension TimeAlone {
    func set(other: TimeAlone) -> TimeAlone {
        self.hour = other.hour
        self.minute = other.minute
        self.second = other.second
        return self
    }
}


public extension TimeAlone {
    func format(clockPartSize: ClockPartSize) -> String { return dateFrom(dateAlone: Date().dateAlone, timeAlone: self).format(dateStyle: ClockPartSize.None, timeStyle: clockPartSize) }
}


