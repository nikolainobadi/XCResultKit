//
//  CIResultManager_MockShellTests.swift
//
//
//  Created by Nikolai Nobadi on 6/15/24.
//

import XCTest
@testable import XCResultKit

final class CIResultManager_MockShellTests: XCTestCase {
    func test_mockShell_outputIsValid() throws {
        MockShell.FileName.allCases.forEach {
            XCTAssertFalse(MockShell(fileName: $0).runCommand("").isEmpty)
        }
    }
}


// MARK: - Unit Tests
extension CIResultManager_MockShellTests {
    func test_extractResults_passingAndFailingJSON_notNil() {
        MockShell.FileName.filesWithTests.forEach {
            XCTAssertNotNil(makeSUT(fileName: $0).extractResults(xcresultPath: ""))
        }
    }
    
    func test_extractResults_cleanAndBuildOnly_actionsAreCorrect() {
        let result = makeSUT(fileName: .cleanAndBuildOnly).extractResults(xcresultPath: "")
        
        assertPropertyEquality(result?.actions.count, expectedProperty: 2)
    }
    
    func test_extractResults_cleanAndBuildOnly_noTestResults() {
        let result = makeSUT(fileName: .cleanAndBuildOnly).extractResults(xcresultPath: "")
        
        assertProperty(result) { ciResult in
            XCTAssertNil(ciResult.testResult)
        }
    }
    
    func test_extractResults_passingAndFailingJSON_actionsAreCorrect() {
        MockShell.FileName.filesWithTests.forEach {
            let result = makeSUT(fileName: $0).extractResults(xcresultPath: "")
            
            assertPropertyEquality(result?.actions.count, expectedProperty: 3)
        }
    }
    
    func test_extractResults_passingJSON_noFailedTestDetails() {
        let result = makeSUT().extractResults(xcresultPath: "")
        
        assertPropertyEquality(result?.testResult?.failedTestDetails.count, expectedProperty: 0)
    }
    
    func test_extractResults_failingJSON_noFailedTestDetails() {
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
