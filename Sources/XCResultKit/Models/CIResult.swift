//
//  CIResult.swift
//  
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

struct CIResult {
    let actions: [CIActionInfo]
    let testResult: CITestResult?
}


// MARK: - CIActionInfo
struct CIActionInfo {
    let type: CIActionType
    let didSucceed: Bool
    let timeInterval: TimeInterval?
}
enum CIActionType: String, CaseIterable {
    case clean, build, test
    var name: String {
        return rawValue.capitalized
    }
}


// MARK: - CITestResult
struct CITestResult {
    let testPlanName: String?
    let totalTests: String?
    let failedTestDetails: [FailedTestCase]
}
struct FailedTestCase {
    let testCaseName: String
    let details: [ErrorDetails]
}
struct ErrorDetails {
    let message: String
    let lineNumber: String?
}
