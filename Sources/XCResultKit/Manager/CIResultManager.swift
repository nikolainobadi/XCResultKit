//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import SwiftShell
import Foundation

public struct CIResultManager {
    let actionInfoMapper = ActionInfoMapper.self
}

// MARK: - Actions
public extension CIResultManager {
    func extractTestResults(from xcresultPath: String) -> CIResult? {
        let output = run(bash: "xcrun xcresulttool get --path \(xcresultPath) --format json").stdout
        
        guard
            let jsonData = output.data(using: .utf8),
            let resultJSON = try? JSONDecoder().decode(XCResultJSON.self, from: jsonData)
        else {
            print("could not extract test results")
            return nil
        }
        
        return makeCIResult(from: resultJSON)
    }
}


// MARK: - Private Methods
private extension CIResultManager {
    func makeCIResult(from json: XCResultJSON) -> CIResult {
        let actions = makeActionInfoList(json)
        let testResult = makeTestResult(json)
        
        return .init(actions: actions, testResult: testResult)
    }
    
    func makeActionInfoList(_ json: XCResultJSON) -> [CIActionInfo] {
        return json.actions.values.map({ actionInfoMapper.makeActionInfo(from: $0) })
    }
    
    func makeTestResult(_ json: XCResultJSON) -> CITestResult? {
        guard let totalTests = json.metrics.testsCount?.value else { return nil }
        
        let failedTestDetails = makeFailedTestDetails(json.issues)
        let testPlanName = json.actions.values.first(where: { $0.name == "Test" })?.testPlanName?.value
        
        return .init(testPlanName: testPlanName, totalTests: totalTests, failedTestDetails: failedTestDetails)
    }
    
    func makeFailedTestDetails(_ issues: XCIssues?) -> [FailedTestCase] {
        guard let issues, let summaries = issues.testFailureSummaries else {
            return []
        }
        
        let groupedSummaries = Dictionary(grouping: summaries.values, by: { $0.testCaseName.value })
        
        return groupedSummaries.map { (testCaseName, values) -> FailedTestCase in
            let details = values.compactMap { summary -> ErrorDetails? in
                let lineNumber = summary.lineNumber
                return ErrorDetails(message: summary.message.value, lineNumber: lineNumber)
            }
            return FailedTestCase(testCaseName: testCaseName, details: details)
        }
    }
}


// MARK: - Extension Dependencies
fileprivate extension FailureSummaryValue {
    var lineNumber: String? {
        guard let line = extractLineNumbers(from: documentLocationInCreatingWorkspace.url.value).startingLine else { return nil }

        return "\(line + 1)"
    }
    private func extractLineNumbers(from urlString: String) -> (startingLine: Int?, endingLine: Int?) {
        guard let url = URL(string: urlString),
              let query = url.fragment else {
            print("Invalid URL")
            return (nil, nil)
        }

        let parameters = query.components(separatedBy: "&").reduce(into: [String: String]()) { (result, param) in
            let components = param.components(separatedBy: "=")
            if components.count == 2 {
                result[components[0]] = components[1]
            }
        }

        let startingLine = parameters["StartingLineNumber"].flatMap(Int.init)
        let endingLine = parameters["EndingLineNumber"].flatMap(Int.init)

        return (startingLine, endingLine)
    }
}
