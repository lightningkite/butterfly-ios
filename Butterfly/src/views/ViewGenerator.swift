// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: views/ViewGenerator.kt
// Package: com.lightningkite.butterfly.views
import UIKit
import Foundation

open class ViewGenerator {
    public init() {
        //Necessary properties should be initialized now
    }
    
    open var title: String {
        get { return "" }
    }
    open var titleString: ViewString {
        get { return ViewStringRaw(string: self.title) }
    }
    
    open func generate(dependency: ViewControllerAccess) -> UIView { TODO() }
    
    public class Default : ViewGenerator {
        override public init() {
            super.init()
            //Necessary properties should be initialized now
        }
        
        override public func generate(dependency: ViewControllerAccess) -> UIView { return newEmptyView(dependency: dependency) }
    }
}


