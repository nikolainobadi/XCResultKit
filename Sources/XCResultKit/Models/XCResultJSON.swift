//
//  XCResultJSON.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

/// `XCResultJSON` represents the JSON structure of an XCResult file.
struct XCResultJSON: Codable {
    let actions: XCAction
    let issues: XCIssues?
    let metrics: XCMetrics
}

// MARK: - ValueItem
/// `ValueItem` represents a value in the XCResult JSON structure.
struct ValueItem: Codable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "_value"
    }
}

// MARK: - XCAction
/// `XCAction` represents the actions in the XCResult JSON structure.
struct XCAction: Codable {
    let values: [ActionValue]
    
    enum CodingKeys: String, CodingKey {
        case values = "_values"
    }
}

/// `ActionValue` provides details about a specific action in the XCResult JSON structure.
struct ActionValue: Codable {
    let title: ValueItem
    let endedTime: ValueItem
    let startedTime: ValueItem
    let testPlanName: ValueItem?
    let buildResult: BuildResult
    let runDestination: RunDestination
}

/// `BuildResult` represents the build result in the XCResult JSON structure.
struct BuildResult: Codable {
    let status: ValueItem
}

/// `RunDestination` provides details about the run destination in the XCResult JSON structure.
struct RunDestination: Codable {
    let displayName: ValueItem
}

// MARK: - XCIssues
/// `XCIssues` represents the issues in the XCResult JSON structure.
struct XCIssues: Codable {
    let testFailureSummaries: TestFailureSummary?
}

/// `TestFailureSummary` provides a summary of test failures in the XCResult JSON structure.
struct TestFailureSummary: Codable {
    let values: [FailureSummaryValue]
    
    enum CodingKeys: String, CodingKey {
        case values = "_values"
    }
}

/// `FailureSummaryValue` provides details about a specific test failure in the XCResult JSON structure.
struct FailureSummaryValue: Codable {
    let message: ValueItem
    let testCaseName: ValueItem
    let documentLocationInCreatingWorkspace: TestFailureLocation
}

/// `TestFailureLocation` represents the location of a test failure in the XCResult JSON structure.
struct TestFailureLocation: Codable {
    let url: ValueItem
}

// MARK: - XCMetrics
/// `XCMetrics` represents the metrics in the XCResult JSON structure.
struct XCMetrics: Codable {
    let testsCount: ValueItem?
    let testsFailedCount: ValueItem?
    let totalCoveragePercentage: ValueItem?
}
