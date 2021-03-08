//
//  UIActivityIndicatorView.binding.actual.swift
//  Butterfly
//
//  Created by Brady on 8/11/20.
//

import Foundation
import UIKit

public extension UIProgressView{
    func bindInt(observable:ObservableProperty<Int>){
        observable.subscribeBy(onNext: {value in
            self.progress = Float(value / 100)
        }).until(self.removed)
    }
    
    func bindLong(observable:ObservableProperty<Int64>){
        observable.subscribeBy(onNext: {value in
            self.progress = Float(value / 100)
        }).until(self.removed)
    }
    
    
    func bindFloat(observable:ObservableProperty<Float>){
        observable.subscribeBy(onNext: {value in
            if value > 1.0 {
                self.progress = 1.0
            } else if value < 0.0 {
                self.progress = 0.0
            }else{
                self.progress =  value
            }
        }).until(self.removed)
    }
}


