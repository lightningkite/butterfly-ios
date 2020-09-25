//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import KeychainAccess

public enum SecurePreferences {
    
    static public let INSTANCE = Self.self
    
    public static var keychain = Keychain(service: (Bundle.main.bundleIdentifier ?? "com.lightningkite.butterfly.unknownApp") + ".securePreferences")
    
    public static func setKeychainAccessGroup(_ name: String) {
        print("Access name is now " + name)
        keychain = Keychain(accessGroup: name)
    }

    public static func set<T: Codable>(key: String, value: T) {
        if let string = try? value.toJsonString() {
            keychain[key] = string
        }
    }

    public static func remove(key: String) -> Void {
        try? keychain.remove(key)
    }

    public static func get<T: Codable>(key: String) -> T? {
        if let string = keychain[key],
            let parsed: T? = try? string.fromJsonString() {
            return parsed
        }
        return nil
    }

    public static func clear() -> Void {
        for key in keychain.allKeys() {
            remove(key)
        }
    }

}
