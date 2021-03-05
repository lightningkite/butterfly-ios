//
//  butterflyTests.swift
//  butterflyTests
//
//  Created by Joseph Ivie on 9/27/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import XCTest
@testable import Butterfly

class DateAloneTests: XCTestCase {
    
    var testDates = (-5000...5000).map {
        Date().dateAlone.safeAddDayOfWeek(value: $0)
    }
    var testDatesPerformance = (-500...500).map {
        Date().dateAlone.safeAddDayOfWeek(value: $0)
    }
    var testDatesShort = (-20...20).map {
        Date().dateAlone.safeAddDayOfWeek(value: $0)
    }

    func testDayOfWeekRead(){
        for date in testDates {
            XCTAssertEqual(date.dayOfWeek, date.safeDayOfWeek, "Failed for \(date.toString())")
        }
    }

    func testDayOfWeek(){
        for testValue in 1...7 {
            for date in testDatesShort {
                let actual = date.dayOfWeek(value:testValue)
                let expected = date.safeDayOfWeek(value:testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }
    func testDayOfMonth(){
        for testValue in 1...28 {
            for date in testDatesShort {
                let actual = date.dayOfMonth(value: testValue)
                let expected = date.safeDayOfMonth(value: testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }
    func testMonthOfYear(){
        for testValue in 1...12 {
            for date in testDatesShort {
                let actual = date.monthOfYear(value:testValue)
                let expected = date.safeMonthOfYear(value:testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }
    func testYearAd(){
        for testValue in 1970...2002 {
            for date in testDates {
                let actual = date.yearAd(value:testValue)
                let expected = date.safeYearAd(value:testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }
    func testAddDayOfWeek(){
        for testValue in -4...4{
            for date in testDates {
                let actual = date.addDayOfWeek(value:testValue)
                let expected = date.safeAddDayOfWeek(value:testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }
    func testAddDayOfMonth(){
        for testValue in -4...4 {
            for date in testDates {
                let actual = date.addDayOfMonth(value:testValue)
                let expected = date.safeAddDayOfMonth(value:testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }
    func testAddMonthOfYear(){
        for testValue in -4...4 {
            for date in testDates {
                let actual = date.addMonthOfYear(value:testValue)
                let expected = date.safeAddMonthOfYear(value:testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }
    func testAddYearAd(){
        for testValue in -4...4{
            for date in testDates {
                let actual = date.addYearAd(value:testValue)
                let expected = date.safeAddYearAd(value:testValue)
                XCTAssertEqual(actual, expected, "Failed for \(date.toString()): expected \(expected.toString()), got \(actual.toString())")
            }
        }
    }

    func testDayOfWeekPerformance(){
        let myStart = Date()
        for testValue in 1...7 {
            for date in testDatesPerformance {
                let actual = date.dayOfWeek(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in 1...7 {
            for date in testDatesPerformance {
                let expected = date.safeDayOfWeek(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }
    func testDayOfMonthPerformance(){
        let myStart = Date()
        for testValue in 1...28 {
            for date in testDatesPerformance {
                let actual = date.dayOfMonth(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in 1...28 {
            for date in testDatesPerformance {
                let expected = date.safeDayOfMonth(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }
    func testMonthOfYearPerformance(){
        let myStart = Date()
        for testValue in 1...12 {
            for date in testDatesPerformance {
                let actual = date.monthOfYear(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in 1...12 {
            for date in testDatesPerformance {
                let expected = date.safeMonthOfYear(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }
    func testYearAdPerformance(){
        let myStart = Date()
        for testValue in 1970...2020 {
            for date in testDatesPerformance {
                let actual = date.yearAd(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in 1970...2020 {
            for date in testDatesPerformance {
                let expected = date.safeYearAd(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }
    func testAddDayOfWeekPerformance(){
        let myStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let actual = date.addDayOfWeek(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let expected = date.safeAddDayOfWeek(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }
    func testAddDayOfMonthPerformance(){
        let myStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let actual = date.addDayOfMonth(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let expected = date.safeAddDayOfMonth(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }
    func testAddMonthOfYearPerformance(){
        let myStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let actual = date.addMonthOfYear(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let expected = date.safeAddMonthOfYear(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }
    func testAddYearAdPerformance(){
        let myStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let actual = date.addYearAd(value:testValue)
            }
        }
        let myDuration = Date().timeIntervalSince(myStart)
        
        print("My: \(myDuration) seconds")
        
        let appleStart = Date()
        for testValue in -4...4 {
            for date in testDatesPerformance {
                let expected = date.safeAddYearAd(value:testValue)
            }
        }
        let appleDuration = Date().timeIntervalSince(appleStart)
        
        print("Apple: \(appleDuration) seconds")
        XCTAssertLessThan(myDuration, appleDuration)
    }

}
