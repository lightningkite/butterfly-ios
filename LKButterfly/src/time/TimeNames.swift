//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation

public class TimeNames {
    
    public static let INSTANCE = TimeNames()
    
    private var formatter = DateFormatter()
    public lazy var shortMonthNames = formatter.shortMonthSymbols!
    public lazy var monthNames = formatter.monthSymbols!
    public  lazy var shortWeekdayNames = formatter.shortWeekdaySymbols!
    public  lazy var weekdayNames = formatter.weekdaySymbols!
    public func shortMonthName(oneIndexedPosition: Int) -> String {
        return shortMonthNames[oneIndexedPosition - 1]
    }
    public func monthName(oneIndexedPosition: Int) -> String {
        return monthNames[oneIndexedPosition - 1]
    }
    public func shortWeekdayName(oneIndexedPosition: Int) -> String {
        return shortWeekdayNames[oneIndexedPosition - 1]
    }
    public func weekdayName(oneIndexedPosition: Int) -> String {
        return weekdayNames[oneIndexedPosition - 1]
    }
}
