//
//  ActionInfoMapper.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

enum ActionInfoMapper {
    static func makeActionInfo(from value: ActionValue) -> CIActionInfo {
        let type = getType(value)
        let didSucceed = value.buildResult.status.value == "succeeded"
        let timeInterval = getTimeInterval(value)
        
        return .init(type: type, didSucceed: didSucceed, timeInterval: timeInterval)
    }
}


// MARK: - Private Methods
private extension ActionInfoMapper {
    static func getType(_ value: ActionValue) -> CIActionType {
        for type in CIActionType.allCases {
            if value.name.contains(type.name) {
                return type
            }
        }
        
        return .test
    }
    
    static func getTimeInterval(_ value: ActionValue) -> TimeInterval? {
        guard let startDate = value.startedTime.value.toFormattedDate(),
              let endDate = value.endedTime.value.toFormattedDate() else {
            print("One or both dates are invalid")
            return nil
        }
        
        return endDate.timeIntervalSince(startDate)
    }
}


// MARK: - Extension Dependencies
extension String {
    func toFormattedDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: self)
    }
}
extension ActionValue {
    var name: String {
        let titleValue = title.value
        
        if titleValue.contains("Clean") {
            return "Clean"
        }
        
        if titleValue.contains("Build") {
            return "Build"
        }
        
        return "Test"
    }
}
