//
//  TestResultMapper.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

/// `TestResultMapper` provides methods to map XCResult JSON data to `CITestResult`.
enum TestResultMapper {
    /// Creates a `CITestResult` from the parsed XCResult JSON.
    /// - Parameter json: The parsed `XCResultJSON`.
    /// - Returns: A `CITestResult` object, or `nil` if required data is missing.
    static func makeTestResult(_ json: XCResultJSON) -> CITestResult? {
        guard let totalTests = json.metrics.testsCount?.value else { return nil }
        
        let failedTestDetails = makeFailedTestDetails(json.issues)
        let testPlanName = json.actions.values.first(where: { $0.name == "Test" })?.testPlanName?.value
        
        return .init(testPlanName: testPlanName, totalTests: totalTests, failedTestDetails: failedTestDetails)
    }
}

// MARK: - Private Methods
private extension TestResultMapper {
    /// Creates a list of `FailedTestCase` from the parsed XCResult JSON issues.
    /// - Parameter issues: The parsed `XCIssues`.
    /// - Returns: A list of `FailedTestCase` objects.
    static func makeFailedTestDetails(_ issues: XCIssues?) -> [FailedTestCase] {
        guard let issues, let summaries = issues.testFailureSummaries else { return [] }
        
        return Dictionary(grouping: summaries.values, by: { $0.testCaseName.value })
            .map { (textCaseName, summaries) in
                let errorDetails = makeErrorDetails(summaries: summaries)
                
                return .init(testCaseName: textCaseName, details: errorDetails)
            }
    }
    
    /// Creates a list of `ErrorDetails` from the failure summaries.
    /// - Parameter summaries: A list of `FailureSummaryValue` objects.
    /// - Returns: A list of `ErrorDetails` objects.
    static func makeErrorDetails(summaries: [FailureSummaryValue]) -> [ErrorDetails] {
        return summaries.compactMap({ .init(message: $0.message.value, lineNumber: $0.lineNumber) })
    }
}

// MARK: - Extension Dependencies
fileprivate extension FailureSummaryValue {
    /// Extracts the line number from the failure location URL.
    var lineNumber: String? {
        guard let url = URL(string: documentLocationInCreatingWorkspace.url.value), let query = url.fragment else { return nil }
        let parameters = query.components(separatedBy: "&").reduce(into: [String: String]()) { (result, param) in
            let components = param.components(separatedBy: "=")
            if components.count == 2 {
                result[components[0]] = components[1]
            }
        }
        guard let line = parameters["StartingLineNumber"].flatMap(Int.init) else { return nil }
        return "\(line + 1)"
    }
}
