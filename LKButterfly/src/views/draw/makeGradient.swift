import Foundation
import CoreGraphics
import UIKit

public func newRadialGradient(
    centerX: CGFloat,
    centerY: CGFloat,
    radius: CGFloat,
    colors: Array<UIColor>,
    stops: Array<CGFloat>,
    tile: Shader.TileMode
) -> ShaderValue {
    return { context in
        context.drawRadialGradient(
            CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors.map { $0.cgColor } as CFArray,
                locations: stops.map { CGFloat($0) }
            )!,
            startCenter: CGPoint(x: CGFloat(centerX), y: CGFloat(centerY)),
            startRadius: 0,
            endCenter: CGPoint(x: CGFloat(centerX), y: CGFloat(centerY)),
            endRadius: radius,
            options: []
        )
    }
}

public func newLinearGradient(x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat, colors: Array<UIColor>, positions: Array<CGFloat>, tile: Shader.TileMode) -> ShaderValue {
    return newLinearGradient(x0, y0, x1, y1, colors, positions, tile)
}

public func newLinearGradient(_ x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat, _ colors: Array<UIColor>, _ positions: Array<CGFloat>, _ tile: Shader.TileMode) -> ShaderValue {
    return { context in
        context.drawLinearGradient(
            CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors.map { $0.cgColor } as CFArray,
                locations: positions.map { CGFloat($0) }
            )!,
            start: CGPoint(x: CGFloat(x0), y: CGFloat(y0)),
            end: CGPoint(x: CGFloat(x1), y: CGFloat(y1)),
            options: []
        )
    }
}
