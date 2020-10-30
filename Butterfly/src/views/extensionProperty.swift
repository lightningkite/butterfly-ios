//
//  extensionProperty.swift
//  ButterflyTemplate
//
//  Created by Joseph Ivie on 8/21/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import Foundation

//public class ExtensionProperty<On: AnyObject, T> {
//
//    public init(){}
//
//    public class T {
//        var value: T
//        init(value: T){
//            self.value = value
//        }
//    }
//    private let table = NSMapTable<On, Box<T>>(keyOptions: .weakMemory, valueOptions: .strongMemory)
//    public func clean(){
//    }
//    public func get(_ from: On) -> T? {
//        return table.object(forKey: from)?.value
//    }
//    public func getOrPut(_ from: On, _ generate: ()->T) -> T {
//        if let value = table.object(forKey: from)?.value { return value }
//        let generated = generate()
//        let box = Box(generated)
//        table.setObject(box, forKey: from)
//        return generated
//    }
//    public func modify(_ from: On, defaultValue:T? = nil, modifier: (inout T)->Void) {
//        if let box = table.object(forKey: from) {
//            modifier(&box.value)
//        } else if let defaultValue = defaultValue {
//            let box = Box(defaultValue)
//            modifier(&box.value)
//            table.setObject(box, forKey: from)
//        }
//    }
//    public func set(_ from: On, _ value: T?) {
//        if let value = value {
//            let box = Box(value)
//            table.setObject(box, forKey: from)
//        } else {
//            table.removeObject(forKey: from)
//        }
//    }
//}


//public class ExtensionProperty<On: AnyObject, T> {
//
//    public init(){}
//
//    static public func selfTest(){
//        let exampleItem = NSObject()
//        let ext = ExtensionProperty<NSObject, Int>()
//
//        ext.set(exampleItem, 1)
//        assert(ext.get(exampleItem) == 1)
//        ({ () in
//            let exampleItem2 = NSObject()
//            assert(ext.get(exampleItem2) == nil)
//        })()
//    }
//
//    private var associateKey: Void = ()
//
//    public func get(_ from: On) -> T? {
//        return (objc_getAssociatedObject(from, &associateKey) as? Box<T>)?.value
//    }
//    public func getOrPut(_ from: On, _ generate: ()->T) -> T {
//        if let x = (objc_getAssociatedObject(from, &associateKey) as? Box<T>) {
//            return x.value
//        }
//        let value = generate()
//        objc_setAssociatedObject(from, &associateKey, Box(value), .OBJC_ASSOCIATION_RETAIN)
//        return value
//    }
//    public func modify(_ from: On, defaultValue:T? = nil, modifier: (inout T)->Void) {
//        let start: T? = (objc_getAssociatedObject(from, &associateKey) as? Box<T>)?.value ?? defaultValue
//        if var value = start {
//            modifier(&value)
//            objc_setAssociatedObject(from, &associateKey, Box(value), .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    public func set(_ from: On, _ value: T?) {
//        if let value = value {
//            objc_setAssociatedObject(from, &associateKey, Box(value), .OBJC_ASSOCIATION_RETAIN)
//        } else {
//            objc_setAssociatedObject(from, &associateKey, nil, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//}



//
//  extensionProperty.swift
//  ButterflyTemplate
//
//  Created by Joseph Ivie on 8/21/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import Foundation

private class WeakObject<T: AnyObject>: Equatable, Hashable, CustomStringConvertible {
    weak var object: T?
    var recordedAddress: ObjectIdentifier
    init(_ object: T) {
        self.object = object
        self.recordedAddress = ObjectIdentifier(object)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(recordedAddress)
    }

    var alive: Bool { return object !== nil }

    static func == (lhs: WeakObject<T>, rhs: WeakObject<T>) -> Bool {
        return lhs.recordedAddress == rhs.recordedAddress
    }
    
    var description: String {
        return String(describing: recordedAddress)
    }
}

public class ExtensionProperty<On: AnyObject, T> {

    static public func selfTest(){
        let exampleItem = NSObject()
        let ext = ExtensionProperty<NSObject, Int>()
        
        DispatchQueue.global(qos: .background).async {
            var delayedChecks: Array<()->Void> = []
            for i in 0...10000 {
                let newItem = NSObject()
                assert(ext.get(newItem) == nil)
                ext.set(newItem, i)
                delayedChecks.append {
                    let newVal = ext.get(newItem)
                    assert(newVal == i)
                }
                if i % 100 == 0 {
                    print("Running checks...")
                    for check in delayedChecks {
                        check()
                    }
                    delayedChecks = []
                }
            }
        }

        ext.set(exampleItem, 1)
        assert(ext.get(exampleItem) == 1)
        ({ () in
            let exampleItem2 = NSObject()
            assert(ext.get(exampleItem2) == nil)
        })()
    }

    public init(){
    }
    private let lock = SpinLock()
    private var table: Dictionary<WeakObject<On>, T> = [:]

    public func get(_ from: On) -> T? {
        checkClean()
        return lock.run {
            let key = WeakObject(from)
            cleanKey(key)
            return table[key]
        }
    }
    public func getOrPut(_ from: On, _ generate: ()->T) -> T {
        checkClean()
        return lock.run {
            let key = WeakObject(from)
            cleanKey(key)
            if let value = table[key] { return value }
            let generated = generate()
            table[key] = generated
            return generated
        }
    }
    public func modify(_ from: On, defaultValue:T? = nil, modifier: (inout T)->Void) {
        lock.run {
            let key = WeakObject(from)
            cleanKey(key)
            if var current = table[key] {
                modifier(&current)
                table[key] = current
            } else if var defaultValue = defaultValue {
                modifier(&defaultValue)
                table[key] = defaultValue
                updateKeyLocked(key)
            }
        }
        checkClean()
    }
    public func set(_ from: On, _ value: T?) {
        lock.run {
            let key = WeakObject(from)
            if let value = value {
                table[key] = value
                updateKeyLocked(key)
            } else {
                table.removeValue(forKey: key)
            }
        }
        checkClean()
    }
    private func updateKeyLocked(_ key: WeakObject<On>) {
        if let index = table.index(forKey: key) {
            table[index].key.object = key.object
        }
    }
    private func cleanKey(_ key: WeakObject<On>) {
        if let index = table.index(forKey: key) {
            if !table[index].key.alive {
                table.remove(at: index)
            }
        }
    }
    public func clean(){
        lock.run {
            let keysToPurge = table.keys.filter { !$0.alive }
            for key in keysToPurge {
                table.removeValue(forKey: key)
            }
        }
    }

    var lastClean = CFAbsoluteTimeGetCurrent()
    var cleanInterval: CFTimeInterval = 10
    private func checkClean(){
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastClean > cleanInterval {
            lastClean = now
            clean()
        }
    }
}

final class SpinLock {
    private var unfairLock = os_unfair_lock_s()
    func run<Result>(action: () -> Result) -> Result {
        os_unfair_lock_lock(&unfairLock)
        let result = action()
        os_unfair_lock_unlock(&unfairLock)
        return result
    }
    func runThrowing<Result>(action: () throws -> Result) throws -> Result {
        os_unfair_lock_lock(&unfairLock)
        do {
            let result = try action()
            os_unfair_lock_unlock(&unfairLock)
            return result
        } catch {
            os_unfair_lock_unlock(&unfairLock)
            throw error
        }
    }
}
