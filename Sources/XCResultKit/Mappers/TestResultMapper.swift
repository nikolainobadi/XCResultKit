//
//  TestResultMapper.swift
//  
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

enum TestResultMapper {
    static func makeTestResult(_ json: XCResultJSON) -> CITestResult? {
        guard let totalTests = json.metrics.testsCount?.value else { return nil }
        
        let failedTestDetails = makeFailedTestDetails(json.issues)
        let testPlanName = json.actions.values.first(where: { $0.name == "Test" })?.testPlanName?.value
        
        return .init(testPlanName: testPlanName, totalTests: totalTests, failedTestDetails: failedTestDetails)
    }
}

// MARK: - Private Methods
private extension TestResultMapper {
    static func makeFailedTestDetails(_ issues: XCIssues?) -> [FailedTestCase] {
        guard let issues, let summaries = issues.testFailureSummaries else {
            return []
        }
        
        return Dictionary(grouping: summaries.values, by: { $0.testCaseName.value })
            .map { (textCaseName, summaries) in
                let errorDetails = makeErrorDetails(summaries: summaries)
                
                return .init(testCaseName: textCaseName, details: errorDetails)
            }
    }
    
    static func makeErrorDetails(summaries: [FailureSummaryValue]) -> [ErrorDetails] {
        return summaries.compactMap({ .init(message: $0.message.value, lineNumber: $0.lineNumber) })
    }
}


// MARK: - Extension Dependencies
fileprivate extension FailureSummaryValue {
    var lineNumber: String? {
        guard let url = URL(string: documentLocationInCreatingWorkspace.url.value), let query = url.fragment else {
            return nil
        }

        let parameters = query.components(separatedBy: "&").reduce(into: [String: String]()) { (result, param) in
            let components = param.components(separatedBy: "=")
            if components.count == 2 {
                result[components[0]] = components[1]
            }
        }

        guard let line = parameters["StartingLineNumber"].flatMap(Int.init) else {
            return nil
        }

        return "\(line + 1)"
    }
}
