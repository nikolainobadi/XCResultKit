//
//  CIResult.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

/// `CIResult` represents the result of a continuous integration (CI) run.
public struct CIResult {
    public let actions: [CIActionInfo]
    public let testResult: CITestResult?
    
    /// Initializes a new `CIResult`.
    /// - Parameters:
    ///   - actions: A list of `CIActionInfo` objects representing CI actions.
    ///   - testResult: An optional `CITestResult` representing the test result.
    public init(actions: [CIActionInfo], testResult: CITestResult?) {
        self.actions = actions
        self.testResult = testResult
    }
}

// MARK: - CIActionInfo
/// `CIActionInfo` provides information about a specific CI action.
public struct CIActionInfo {
    public let type: CIActionType
    public let didSucceed: Bool
    public let timeInterval: TimeInterval?
    
    /// Initializes a new `CIActionInfo`.
    /// - Parameters:
    ///   - type: The type of the CI action.
    ///   - didSucceed: A boolean indicating whether the action succeeded.
    ///   - timeInterval: An optional time interval for the action.
    public init(type: CIActionType, didSucceed: Bool, timeInterval: TimeInterval?) {
        self.type = type
        self.didSucceed = didSucceed
        self.timeInterval = timeInterval
    }
}

/// `CIActionType` represents different types of CI actions.
public enum CIActionType: String, CaseIterable {
    case clean, build, test
    
    /// Returns the capitalized name of the action type.
    public var name: String {
        return rawValue.capitalized
    }
}

// MARK: - CITestResult
/// `CITestResult` represents the result of a test run in CI.
public struct CITestResult {
    public let testPlanName: String?
    public let totalTests: String?
    public let failedTestDetails: [FailedTestCase]
    
    /// Initializes a new `CITestResult`.
    /// - Parameters:
    ///   - testPlanName: An optional name of the test plan.
    ///   - totalTests: An optional total number of tests.
    ///   - failedTestDetails: A list of `FailedTestCase` objects.
    public init(testPlanName: String?, totalTests: String?, failedTestDetails: [FailedTestCase]) {
        self.testPlanName = testPlanName
        self.totalTests = totalTests
        self.failedTestDetails = failedTestDetails
    }
}

/// `FailedTestCase` provides details about a failed test case.
public struct FailedTestCase {
    public let testCaseName: String
    public let details: [ErrorDetails]
    
    /// Initializes a new `FailedTestCase`.
    /// - Parameters:
    ///   - testCaseName: The name of the failed test case.
    ///   - details: A list of `ErrorDetails` objects.
    public init(testCaseName: String, details: [ErrorDetails]) {
        self.testCaseName = testCaseName
        self.details = details
    }
}

/// `ErrorDetails` provides details about an error that occurred during a test case.
public struct ErrorDetails {
    public let message: String
    public let lineNumber: String?
    
    /// Initializes a new `ErrorDetails`.
    /// - Parameters:
    ///   - message: The error message.
    ///   - lineNumber: An optional line number where the error occurred.
    public init(message: String, lineNumber: String?) {
        self.message = message
        self.lineNumber = lineNumber
    }
}
