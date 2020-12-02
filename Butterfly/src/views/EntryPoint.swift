// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: views/EntryPoint.kt
// Package: com.lightningkite.butterfly.views
import Foundation

public protocol EntryPoint: HasBackAction {
    
    func handleDeepLink(schema: String, host: String, path: String, params: Dictionary<String, String>) -> Void 
    var mainStack: ObservableStack<ViewGenerator>? { get }
    
}
public extension EntryPoint {
    func handleDeepLink(schema: String, host: String, path: String, params: Dictionary<String, String>) -> Void {
        print("Empty handler; \(schema)://\(host)/\(path)/\(params)")
    }
    var mainStack: ObservableStack<ViewGenerator>? {
        get { return nil }
    }
}


