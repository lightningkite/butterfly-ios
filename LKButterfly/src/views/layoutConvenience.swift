//
//  layoutConvenience.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/14/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import UIKit

public enum LayoutSettings {
    static let debugDraw = false
}

public extension UIView {
    func addSubview<T: UIView>(_ view: T, setup: (T)->Void) {
        setup(view)
        self.addSubview(view)
    }
}

public extension LinearLayout {
    func addSubview<T: UIView>(
        _ view: T,
        minimumSize: CGSize = .zero,
        size: CGSize = .zero,
        margin: UIEdgeInsets = .zero,
        padding: UIEdgeInsets = .zero,
        gravity: AlignPair = .center,
        weight: CGFloat = 0,
        setup: (T)->Void
    ) {
        setup(view)
        self.addSubview(view, minimumSize: minimumSize, size: size, margin: margin, padding: padding, gravity: gravity, weight: weight)
    }
}


public extension FrameLayout {
    func addSubview<T: UIView>(
        _ view: T,
        minimumSize: CGSize = .zero,
        size: CGSize = .zero,
        margin: UIEdgeInsets = .zero,
        padding: UIEdgeInsets = .zero,
        gravity: AlignPair = .center,
        setup: (T)->Void
    ) {
        setup(view)
        self.addSubview(view, minimumSize: minimumSize, size: size, margin: margin, padding: padding, gravity: gravity)
    }
}
