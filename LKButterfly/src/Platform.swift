//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation

public enum Platform: StringEnum {
    public static let Companion = Self.self
    public static let INSTANCE = Self.self
    case iOS, Android, Web
    public static let current = Platform.iOS
}
