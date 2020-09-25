// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: net/HttpModels.kt
// Package: com.lightningkite.butterfly.net
import Foundation

public enum HttpPhase: String, KEnum, StringEnum, CaseIterable {
    case Connect
    case Write
    case Waiting
    case Read
    case Done
    
    public init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .Connect
    }
}

public class HttpProgress : KDataClass {
    public var phase: HttpPhase
    public var ratio: Float
    public init(phase: HttpPhase, ratio: Float) {
        self.phase = phase
        self.ratio = ratio
        //Necessary properties should be initialized now
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(phase)
        hasher.combine(ratio)
    }
    public static func == (lhs: HttpProgress, rhs: HttpProgress) -> Bool { return lhs.phase == rhs.phase && lhs.ratio == rhs.ratio }
    public var description: String { return "HttpProgress(phase = \(self.phase), ratio = \(self.ratio))" }
    public func copy(phase: HttpPhase? = nil, ratio: Float? = nil) -> HttpProgress { return HttpProgress(phase: phase ?? self.phase, ratio: ratio ?? self.ratio) }
    
    public var approximate: Float {
        get { return run { () -> Float in 
                switch self.phase {
                    case HttpPhase.Connect:
                    return 0
                    break
                    case HttpPhase.Write:
                    return 0.15 + 0.5 * self.ratio
                    break
                    case HttpPhase.Waiting:
                    return 0.65
                    break
                    case HttpPhase.Read:
                    return 0.7 + 0.3 * self.ratio
                    break
                    case HttpPhase.Done:
                    return 1
                    break
                    default:
                    return 0
                    break
                }
                
        } }
    }
    public class Companion {
        public init() {
            self.connecting = HttpProgress(phase: HttpPhase.Connect, ratio: 0)
            self.waiting = HttpProgress(phase: HttpPhase.Waiting, ratio: 0)
            self.done = HttpProgress(phase: HttpPhase.Done, ratio: 0)
            //Necessary properties should be initialized now
        }
        public static let INSTANCE = Companion()
        
        public let connecting: HttpProgress
        public let waiting: HttpProgress
        public let done: HttpProgress
    }
}

public class HttpOptions : KDataClass {
    public var callTimeout: Int64?
    public var writeTimeout: Int64?
    public var readTimeout: Int64?
    public var connectTimeout: Int64?
    public var cacheMode: HttpCacheMode
    public init(callTimeout: Int64? = nil, writeTimeout: Int64? = 10000, readTimeout: Int64? = 10000, connectTimeout: Int64? = 10000, cacheMode: HttpCacheMode = HttpCacheMode.Default) {
        self.callTimeout = callTimeout
        self.writeTimeout = writeTimeout
        self.readTimeout = readTimeout
        self.connectTimeout = connectTimeout
        self.cacheMode = cacheMode
        //Necessary properties should be initialized now
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(callTimeout)
        hasher.combine(writeTimeout)
        hasher.combine(readTimeout)
        hasher.combine(connectTimeout)
        hasher.combine(cacheMode)
    }
    public static func == (lhs: HttpOptions, rhs: HttpOptions) -> Bool { return lhs.callTimeout == rhs.callTimeout && lhs.writeTimeout == rhs.writeTimeout && lhs.readTimeout == rhs.readTimeout && lhs.connectTimeout == rhs.connectTimeout && lhs.cacheMode == rhs.cacheMode }
    public var description: String { return "HttpOptions(callTimeout = \(self.callTimeout), writeTimeout = \(self.writeTimeout), readTimeout = \(self.readTimeout), connectTimeout = \(self.connectTimeout), cacheMode = \(self.cacheMode))" }
    public func copy(callTimeout: Int64?? = .some(nil), writeTimeout: Int64?? = .some(nil), readTimeout: Int64?? = .some(nil), connectTimeout: Int64?? = .some(nil), cacheMode: HttpCacheMode? = nil) -> HttpOptions { return HttpOptions(callTimeout: invertOptional(callTimeout) ?? self.callTimeout, writeTimeout: invertOptional(writeTimeout) ?? self.writeTimeout, readTimeout: invertOptional(readTimeout) ?? self.readTimeout, connectTimeout: invertOptional(connectTimeout) ?? self.connectTimeout, cacheMode: cacheMode ?? self.cacheMode) }
}

public enum HttpCacheMode: String, KEnum, StringEnum, CaseIterable {
    case Default
    case NoStore
    case Reload
    case NoCache
    case ForceCache
    case OnlyIfCached
    
    public init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .Default
    }
}


