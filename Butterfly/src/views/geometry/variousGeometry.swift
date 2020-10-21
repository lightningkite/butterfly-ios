//
//  Layouting.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/12/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import UIKit

public enum Dimension {
    case x, y
}

public extension Dimension {
    var axis: NSLayoutConstraint.Axis {
        switch self {
        case .x:
            return .horizontal
        case .y:
            return .vertical
        }
    }
    var other: Dimension {
        switch self {
        case .x:
            return .y
        case .y:
            return .x
        }
    }
}

public extension AlignPair {
    subscript(dimension: Dimension) -> Align {
        get {
            switch dimension {
            case .x:
                return self.horizontal
            case .y:
                return self.vertical
            }
        }
    }
}

public extension CGSize {
    func expand(_ rhs: CGSize) -> CGSize {
        return CGSize(width: max(self.width, rhs.width), height: max(self.height, rhs.height))
    }

    subscript(dimension: Dimension) -> CGFloat {
        get {
            switch dimension {
            case .x:
                return self.width
            case .y:
                return self.height
            }
        }
        set(value) {
            switch dimension {
            case .x:
                self.width = value
            case .y:
                self.height = value
            }
        }
    }
}

public extension CGPoint {
    subscript(dimension: Dimension) -> CGFloat {
        get {
            switch dimension {
            case .x:
                return self.x
            case .y:
                return self.y
            }
        }
        set(value) {
            switch dimension {
            case .x:
                self.x = value
            case .y:
                self.y = value
            }
        }
    }
}

public extension UIEdgeInsets {
    func start(_ dimension: Dimension) -> CGFloat {
        switch dimension {
        case .x:
            return self.left
        case .y:
            return self.top
        }
    }
    func end(_ dimension: Dimension) -> CGFloat {
        switch dimension {
        case .x:
            return self.right
        case .y:
            return self.bottom
        }
    }
    func total(_ dimension: Dimension) -> CGFloat {
        switch dimension {
        case .x:
            return self.left + self.right
        case .y:
            return self.top + self.bottom
        }
    }
}

public protocol HasAnchors {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}
extension UIView: HasAnchors {}
extension UILayoutGuide: HasAnchors {}
public extension HasAnchors {
    func startAnchor(_ orientation: Dimension) -> NSLayoutAnchorGeneric {
        switch orientation {
        case .x:
            return leadingAnchor
        case .y:
            return topAnchor
        }
    }
    func endAnchor(_ orientation: Dimension) -> NSLayoutAnchorGeneric {
        switch orientation {
        case .x:
            return trailingAnchor
        case .y:
            return bottomAnchor
        }
    }
    func centerAnchor(_ orientation: Dimension) -> NSLayoutAnchorGeneric {
        switch orientation {
        case .x:
            return centerXAnchor
        case .y:
            return centerYAnchor
        }
    }
    func sizeAnchor(_ orientation: Dimension) -> NSLayoutDimension {
        switch orientation {
        case .x:
            return widthAnchor
        case .y:
            return heightAnchor
        }
    }
}

public protocol NSLayoutAnchorGeneric {
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor.
    func constraintD(equalTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint
    func constraintD(greaterThanOrEqualTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint
    func constraintD(lessThanOrEqualTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint

    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor + constant.
    func constraintD(equalTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint
    func constraintD(greaterThanOrEqualTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint
    func constraintD(lessThanOrEqualTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutXAxisAnchor: NSLayoutAnchorGeneric {
    public func constraintD(equalTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor as! Self)
    }
    
    public func constraintD(greaterThanOrEqualTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor as! Self)
    }
    
    public func constraintD(lessThanOrEqualTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor as! Self)
    }
    
    public func constraintD(equalTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor as! Self, constant: c)
    }
    
    public func constraintD(greaterThanOrEqualTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor as! Self, constant: c)
    }
    
    public func constraintD(lessThanOrEqualTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor as! Self, constant: c)
    }
}

extension NSLayoutYAxisAnchor: NSLayoutAnchorGeneric {
    public func constraintD(equalTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor as! Self)
    }
    
    public func constraintD(greaterThanOrEqualTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor as! Self)
    }
    
    public func constraintD(lessThanOrEqualTo anchor: NSLayoutAnchorGeneric) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor as! Self)
    }
    
    public func constraintD(equalTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor as! Self, constant: c)
    }
    
    public func constraintD(greaterThanOrEqualTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor as! Self, constant: c)
    }
    
    public func constraintD(lessThanOrEqualTo anchor: NSLayoutAnchorGeneric, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor as! Self, constant: c)
    }
}
