//
//  ActionInfoMapperTests.swift
//
//
//  Created by Nikolai Nobadi on 6/15/24.
//

import XCTest
import NnTestHelpers
@testable import XCResultKit

final class ActionInfoMapperTests: XCTestCase {
    func test_makeActionInfo_typeIsCorrect() {
        let sut = makeSUT()
        
        ActionValueTitle.allCases.forEach { title in
            let value = makeActionValue(title: title)
            let info = sut.makeActionInfo(from: value)
            
            XCTAssertEqual(info.type, title.type)
        }
    }
    
    func test_makeActionInfo_didSucceedIsCorrect() {
        XCTAssert(makeSUT().makeActionInfo(from: makeActionValue(title: .buildTitle)).didSucceed)
        XCTAssertFalse(makeSUT().makeActionInfo(from: makeActionValue(title: .buildTitle, status: "")).didSucceed)
    }
    
    func test_makeActionInfo_timeIntervalIsCorrect() {
        let start = Date().toCustomString(withHour: 8, minute: 0, second: 0, millisecond: 0)
        let end = Date().toCustomString(withHour: 8, minute: 5, second: 0, millisecond: 0)
        let value = makeActionValue(title: .buildTitle, endedTime: end, startedTime: start)
        let info = makeSUT().makeActionInfo(from: value)
        let expectedProperty: TimeInterval = 5 * 60
        
        assertPropertyEquality(info.timeInterval, expectedProperty: expectedProperty)
    }
}


// MARK: - SUT
extension ActionInfoMapperTests {
    func makeSUT() -> ActionInfoMapper.Type {
        return ActionInfoMapper.self
    }
    
    
}


// MARK: - Extension Dependencies
extension Date {
    func toCustomString(withHour hour: Int, minute: Int, second: Int, millisecond: Int) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        dateComponents.nanosecond = millisecond * 1_000_000
        
        guard let customDate = calendar.date(from: dateComponents) else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: customDate)
    }
}

