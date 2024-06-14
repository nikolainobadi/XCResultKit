//
//  XCResultJSON.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

struct XCResultJSON: Codable {
    let actions: XCAction
    let issues: XCIssues?
    let metrics: XCMetrics
}


// MARK: - ValueItem
struct ValueItem: Codable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "_value"
    }
}

// MARK: - XCAction
struct XCAction: Codable {
    let values: [ActionValue]
    
    enum CodingKeys: String, CodingKey {
        case values = "_values"
    }
}
struct ActionValue: Codable {
    let title: ValueItem
    let endedTime: ValueItem
    let startedTime: ValueItem
    let testPlanName: ValueItem?
    let buildResult: BuildResult
    let runDestination: RunDestination
}
struct BuildResult: Codable {
    let status: ValueItem
}
struct RunDestination: Codable {
    let displayName: ValueItem
}

// MARK: - XCIssues
struct XCIssues: Codable {
    let testFailureSummaries: TestFailureSummary?
}
struct TestFailureSummary: Codable {
    let values: [FailureSummaryValue]
    
    enum CodingKeys: String, CodingKey {
        case values = "_values"
    }
}
struct FailureSummaryValue: Codable {
    let message: ValueItem
    let testCaseName: ValueItem
    let documentLocationInCreatingWorkspace: TestFailureLocation
}
struct TestFailureLocation: Codable {
    let url: ValueItem
}

// MARK: - XCMetrics
struct XCMetrics: Codable {
    let testsCount: ValueItem?
    let testsFailedCount: ValueItem?
    let totalCoveragePercentage: ValueItem?
}
