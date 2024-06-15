//
//  XCTestCase+Extensions.swift
//
//
//  Created by Nikolai Nobadi on 6/15/24.
//

import XCTest
@testable import XCResultKit

extension XCTestCase {
    enum ActionValueTitle: String, CaseIterable {
        case cleanTitle = "Clean \"SampleApp\""
        case buildTitle = "Build \"SampleApp\""
        case testTitle = "Testing project SampleApp with scheme SampleApp"
        
        var type: CIActionType {
            switch self {
            case .cleanTitle:
                return .clean
            case .buildTitle:
                return .build
            case .testTitle:
                return .test
            }
        }
    }
}


// MARK: - Helper Methods
extension XCTestCase {
    func makeValueItem(_ value: String?) -> ValueItem? {
        guard let value else { return nil }
        return .init(value: value)
    }
    
    func makeActionValue(title: ActionValueTitle, endedTime: String? = nil, startedTime: String? = nil, testPlanName: String? = nil, status: String = "succeeded", destination: String? = nil) -> ActionValue {
        
        let endedTime = endedTime ?? "2024-06-15T13:30:39.936-0700"
        let startedTime = startedTime ?? "2024-06-15T13:30:39.683-0700"
        let destination = destination ?? "iPhone 15 Pro"
        
        return .init(
            title: .init(value: title.rawValue),
            endedTime: .init(value: endedTime),
            startedTime: .init(value: startedTime),
            testPlanName: testPlanName == nil ? nil : .init(value: testPlanName!),
            buildResult: .init(status: .init(value: status)),
            runDestination: .init(displayName: .init(value: destination))
        )
    }
}
