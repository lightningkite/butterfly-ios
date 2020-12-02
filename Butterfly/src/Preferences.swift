//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation

public enum Preferences {
    static public let INSTANCE = Self.self
    public static func set<T: Codable>(key: String, value: T) {
        UserDefaults.standard.setValue(value.toJsonString(), forKey: key)
    }
    public static func remove(key: String) -> Void {
        UserDefaults.standard.removeObject(forKey: key)
    }
    public static func get<T: Codable>(key: String) -> T? {
        if let string = UserDefaults.standard.string(forKey: key) {
            return string.fromJsonString()
        }
        return nil
    }
    public static func clear() -> Void {
        for k in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: k)
        }
    }
}
