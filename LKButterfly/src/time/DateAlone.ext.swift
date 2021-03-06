// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: time/DateAlone.ext.kt
// Package: com.lightningkite.butterfly.time
import Foundation

public extension DateAlone {
    func set(other: DateAlone) -> DateAlone {
        self.year = other.year
        self.month = other.month
        self.day = other.day
        return self
    }
}

public extension DateAlone {
    func format(clockPartSize: ClockPartSize) -> String { return dateFrom(dateAlone: self, timeAlone: TimeAlone.Companion.INSTANCE.noon).format(dateStyle: clockPartSize, timeStyle: ClockPartSize.None) }
}


