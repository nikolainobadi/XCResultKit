//
//  TestResultMapperTests.swift
//
//
//  Created by Nikolai Nobadi on 6/15/24.
//

import XCTest
import NnTestHelpers
@testable import XCResultKit

final class TestResultMapperTests: XCTestCase {
    func test_makeTestResult_returnsNil_whenTestCountIsNil() {
        XCTAssertNil(makeSUT().makeTestResult(makeJSON()))
    }
    
    func test_makeTestResult_testPlanNameIsNil_whenTestActionIsMissing() {
        let metrics = makeMetrics(testCount: "1")
        let json = makeJSON(metrics: metrics)
        let result = makeSUT().makeTestResult(json)
        
        assertProperty(result) { testResults in
            XCTAssertNil(testResults.testPlanName)
        }
    }
    
    func test_makeTestResult_failureDetailsIsEmpty_whenIssuesIsNil() {
        let issues = makeIssues(summary: makeTestFailureSummary())
        let metrics = makeMetrics(testCount: "1")
        let json = makeJSON(issues: issues, metrics: metrics)
        let results = makeSUT().makeTestResult(json)
        
        assertPropertyEquality(results?.failedTestDetails.count, expectedProperty: 0)
    }
    
    func test_makeTestResult_errorsWithinSameMethod_areSavedInSingleFailedTestDetails() {
        let firstMethodName = "test_firstMethod()"
        let secondMethodName = "test_otherMethod()"
        let firstError = makeFailureValue(testCaseName: firstMethodName, lineNumber: 20)
        let secondError = makeFailureValue(testCaseName: firstMethodName, lineNumber: 25)
        let thirdError = makeFailureValue(testCaseName: secondMethodName, lineNumber: 50)
        let allErrors = [firstError, secondError, thirdError]
        let summary = makeTestFailureSummary(values: allErrors)
        let issues = makeIssues(summary: summary)
        let metrics = makeMetrics(testCount: "\(allErrors.count + 1)")
        let json = makeJSON(issues: issues, metrics: metrics)
        let results = makeSUT().makeTestResult(json)
        
        assertProperty(results) { testResults in
            XCTAssertEqual(testResults.failedTestDetails.count, 2)
            [firstMethodName, secondMethodName].forEach { testName in
                XCTAssertTrue(testResults.failedTestDetails.contains(where: { $0.testCaseName == testName }))
            }
        }
        
        assertPropertyEquality(results?.failedTestDetails.first(where: { $0.testCaseName == firstMethodName })?.details.count, expectedProperty: 2)
    }
}


// MARK: - SUT
extension TestResultMapperTests {
    func makeSUT() -> TestResultMapper.Type {
        return TestResultMapper.self
    }
    
    func makeJSON(action: XCAction? = nil, issues: XCIssues? = nil, metrics: XCMetrics? = nil) -> XCResultJSON {
        return .init(actions: action ?? makeAction(), issues: issues, metrics: metrics ?? makeMetrics())
    }
    
    func makeAction(values: [ActionValue] = []) -> XCAction {
        return .init(values: values)
    }
    
    func makeIssues(summary: TestFailureSummary? = nil) -> XCIssues {
        return .init(testFailureSummaries: summary)
    }
    
    func makeTestFailureSummary(values: [FailureSummaryValue] = []) -> TestFailureSummary {
        return .init(values: values)
    }
    
    func makeFailureValue(message: String = "some kind of error", testCaseName: String = "test_methodName()", lineNumber: Int = 22) -> FailureSummaryValue {
        let url = "file:///Users/nelix/Desktop/SampleApp/SampleApp/Tests/UnitTests/ContentViewModelTests.swift#EndingLineNumber=\(lineNumber)&StartingLineNumber=\(lineNumber)"
        
        return .init(message: .init(value: message), testCaseName: .init(value: testCaseName), documentLocationInCreatingWorkspace: .init(url: .init(value: url)))
    }
    
    func makeMetrics(testCount: String? = nil, failedCount: String? = nil) -> XCMetrics {
        return .init(testsCount: makeValueItem(testCount), testsFailedCount: makeValueItem(failedCount), totalCoveragePercentage: nil)
    }
}
