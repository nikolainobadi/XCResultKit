//
//  ActionInfoMapper.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

/// `ActionInfoMapper` provides methods to map XCResult JSON data to `CIActionInfo`.
enum ActionInfoMapper {
    /// Creates a `CIActionInfo` from the parsed action value.
    /// - Parameter value: The parsed `ActionValue`.
    /// - Returns: A `CIActionInfo` object.
    static func makeActionInfo(from value: ActionValue) -> CIActionInfo {
        let type = getType(value)
        let didSucceed = value.buildResult.status.value == "succeeded"
        let timeInterval = getTimeInterval(value)
        
        return .init(type: type, didSucceed: didSucceed, timeInterval: timeInterval)
    }
}


// MARK: - Private Methods
private extension ActionInfoMapper {
    /// Determines the `CIActionType` from the action value.
    /// - Parameter value: The parsed `ActionValue`.
    /// - Returns: The corresponding `CIActionType`.
    static func getType(_ value: ActionValue) -> CIActionType {
        for type in CIActionType.allCases {
            if value.name.contains(type.name) {
                return type
            }
        }
        return .test
    }
    
    /// Calculates the time interval for the action.
    /// - Parameter value: The parsed `ActionValue`.
    /// - Returns: The time interval, or `nil` if the dates are invalid.
    static func getTimeInterval(_ value: ActionValue) -> TimeInterval? {
        guard let startDate = value.startedTime.value.toFormattedDate(), let endDate = value.endedTime.value.toFormattedDate() else {
            print("One or both dates are invalid")
            return nil
        }
        return endDate.timeIntervalSince(startDate)
    }
}

// MARK: - Extension Dependencies
fileprivate extension String {
    /// Converts a string to a formatted date.
    /// - Returns: A `Date` object, or `nil` if the string cannot be parsed.
    func toFormattedDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: self)
    }
}
