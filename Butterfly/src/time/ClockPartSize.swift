// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: time/ClockPartSize.kt
// Package: com.lightningkite.butterfly.time
import Foundation

public enum ClockPartSize: String, KEnum, StringEnum, CaseIterable {
    case None
    case Short
    case Medium
    case Long
    case Full
    
    public init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .None
    }
}



