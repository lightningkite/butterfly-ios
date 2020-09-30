import UIKit

public struct StateSelector<T> {
    public let normal: T
    public let selected: T?
    public let disabled: T?
    public let highlighted: T?
    public let focused: T?

    public init(
        normal: T,
        selected: T? = nil,
        disabled: T? = nil,
        highlighted: T? = nil,
        focused: T? = nil
    ) {
        self.normal = normal
        self.selected = selected
        self.highlighted = highlighted
        self.disabled = disabled
        self.focused = focused
    }

    public func get(_ state: UIControl.State) -> T {
        if state.contains(.focused), let value = focused {
            return value
        }
        if state.contains(.highlighted), let value = highlighted {
            return value
        }
        if state.contains(.disabled), let value = disabled {
            return value
        }
        if state.contains(.selected), let value = selected {
            return value
        }
        return normal
    }
}