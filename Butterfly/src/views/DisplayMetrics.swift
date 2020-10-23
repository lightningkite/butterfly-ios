//
//  DisplayMetrics.actual.swift
//  Butterfly
//
//  Created by Joseph Ivie on 1/4/20.
//

import Foundation
import CoreGraphics

public struct DisplayMetrics {
    public let density: CGFloat
    public let scaledDensity: CGFloat
    public let widthPixels: Int
    public let heightPixels: Int
    
    public init(
        density: CGFloat,
        scaledDensity: CGFloat,
        widthPixels: Int,
        heightPixels: Int
    ) {
        self.density = density
        self.scaledDensity = scaledDensity
        self.widthPixels = widthPixels
        self.heightPixels = heightPixels
    }
}
