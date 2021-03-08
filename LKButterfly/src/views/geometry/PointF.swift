//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit


//--- CGRect.{
extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher){
        hasher.combine(x)
        hasher.combine(y)
    }
}
