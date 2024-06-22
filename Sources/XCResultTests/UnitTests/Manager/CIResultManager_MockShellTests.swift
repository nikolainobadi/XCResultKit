//
//  CIResultManager_MockShellTests.swift
//
//
//  Created by Nikolai Nobadi on 6/15/24.
//

import XCTest
@testable import XCResultKit

final class CIResultManager_MockShellTests: XCTestCase {
    func test_mockShell_outputs_valid_results_for_all_file_cases() throws {
        MockShell.FileName.allCases.forEach {
            XCTAssertFalse(MockShell(fileName: $0).runCommand("").isEmpty)
        }
    }
}

// MARK: - Unit Tests
extension CIResultManager_MockShellTests {
    func test_returns_non_nil_for_all_test_JSON_files() {
        MockShell.FileName.filesWithTests.forEach {
            XCTAssertNotNil(makeSUT(fileName: $0).extractResults(xcresultPath: ""))
        }
    }
    
    func test_clean_and_build_only_contains_two_actions() {
        let result = makeSUT(fileName: .cleanAndBuildOnly).extractResults(xcresultPath: "")
        
        assertPropertyEquality(result?.actions.count, expectedProperty: 2)
    }
    
    func test_clean_and_build_has_no_test_results() {
        let result = makeSUT(fileName: .cleanAndBuildOnly).extractResults(xcresultPath: "")
        
        assertProperty(result) { ciResult in
            XCTAssertNil(ciResult.testResult)
        }
    }
    
    func test_passing_and_failing_tests_contain_three_actions() {
        MockShell.FileName.filesWithTests.forEach {
            let result = makeSUT(fileName: $0).extractResults(xcresultPath: "")
            
            assertPropertyEquality(result?.actions.count, expectedProperty: 3)
        }
    }
    
    func test_passing_tests_have_no_failed_test_details() {
        let result = makeSUT().extractResults(xcresultPath: "")
        
        assertPropertyEquality(result?.testResult?.failedTestDetails.count, expectedProperty: 0)
    }
    
    func test_failing_tests_have_failed_test_details() {
        let result = makeSUT(fileName: .failure).extractResults(xcresultPath: "")
        
        assertProperty(result?.testResult) { testResults in
            XCTAssertFalse(testResults.failedTestDetails.isEmpty)
        }
    }
}

// MARK: - SUT
extension CIResultManager_MockShellTests {
    func makeSUT(fileName: MockShell.FileName = .passing) -> CIResultManager {
        let shell = MockShell(fileName: fileName)
        
        return .init(shell: shell)
    }
}

// MARK: - Helper Classes
extension CIResultManager_MockShellTests {
    class MockShell: Shell {
        private let fileName: FileName
        enum FileName: String, CaseIterable {
            case passing = "PassingTestResults"
            case failure = "FailingTestResults"
            case cleanAndBuildOnly = "CleanAndBuildOnly"
            static var filesWithTests: [FileName] {
                return [.passing, .failure]
            }
        }
        
        init(fileName: FileName) {
            self.fileName = fileName
        }
        
        func runCommand(_ command: String) -> String {
            let bundle = Bundle.module
            guard let fileURL = bundle.url(forResource: fileName.rawValue, withExtension: "json", subdirectory: "Resources/JSONResults") else {
                XCTFail("File not found")
                return ""
            }
            
            do {
                return try String(contentsOf: fileURL, encoding: .utf8)
            } catch {
                XCTFail("Failed to read file contents: \(error)")
                return ""
            }
        }
    }
}
