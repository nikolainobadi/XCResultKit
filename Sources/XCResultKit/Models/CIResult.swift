//
//  CIResult.swift
//  
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

public struct CIResult {
    public let actions: [CIActionInfo]
    public let testResult: CITestResult?
    
    public init(actions: [CIActionInfo], testResult: CITestResult?) {
        self.actions = actions
        self.testResult = testResult
    }
}


// MARK: - CIActionInfo
public struct CIActionInfo {
    public let type: CIActionType
    public let didSucceed: Bool
    public let timeInterval: TimeInterval?
    public init(type: CIActionType, didSucceed: Bool, timeInterval: TimeInterval?) {
        self.type = type
        self.didSucceed = didSucceed
        self.timeInterval = timeInterval
    }
}
public enum CIActionType: String, CaseIterable {
    case clean, build, test
    public var name: String {
        return rawValue.capitalized
    }
}


// MARK: - CITestResult
public struct CITestResult {
    public let testPlanName: String?
    public let totalTests: String?
    public let failedTestDetails: [FailedTestCase]
    public init(testPlanName: String?, totalTests: String?, failedTestDetails: [FailedTestCase]) {
        self.testPlanName = testPlanName
        self.totalTests = totalTests
        self.failedTestDetails = failedTestDetails
    }
}
public struct FailedTestCase {
    public let testCaseName: String
    public let details: [ErrorDetails]
    public init(testCaseName: String, details: [ErrorDetails]) {
        self.testCaseName = testCaseName
        self.details = details
    }
}
public struct ErrorDetails {
    public let message: String
    public let lineNumber: String?
    public init(message: String, lineNumber: String?) {
        self.message = message
        self.lineNumber = lineNumber
    }
}
