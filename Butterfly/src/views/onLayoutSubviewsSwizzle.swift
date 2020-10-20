//
//  onLayoutSubviewsSwizzle.swift
//  ButterflyTemplate
//
//  Created by Joseph Ivie on 8/6/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

extension UIView {

    public func addOnLayoutSubviews(action:@escaping ()->Void) {
        action()
        let observer = self.layer.observe(\.bounds) { object, _ in
            action()
        }
        self.removed.call(DisposableLambda { observer.invalidate() })
    }
    public var onLayoutSubviews: Observable<UIView> {
        let subj = PublishSubject<UIView>()
        let observer = self.layer.observe(\.bounds) { [weak self] object, _ in
            if let self = self {
                subj.onNext(self)
            }
        }
        self.removed.call(DisposableLambda { observer.invalidate() })
        return subj
    }
}
