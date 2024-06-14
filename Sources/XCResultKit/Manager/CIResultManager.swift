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
    let testResultMapper = TestResultMapper.self
}

// MARK: - Actions
public extension CIResultManager {
    func extractResults(xcresultPath: String) -> CIResult? {
        guard let result = getResultJSON(path: xcresultPath) else {
            return nil
        }
        
        let actions = makeActionInfoList(result)
        let testResult = testResultMapper.makeTestResult(result)
        
        return .init(actions: actions, testResult: testResult)
    }
}


// MARK: - Private Methods
private extension CIResultManager {
    func getResultJSON(path: String) -> XCResultJSON? {
        let output = run(bash: "xcrun xcresulttool get --path \(path) --format json").stdout
        
        guard let jsonData = output.data(using: .utf8) else {
            return nil
        }
        
        return try? JSONDecoder().decode(XCResultJSON.self, from: jsonData)
    }
    
    func makeActionInfoList(_ json: XCResultJSON) -> [CIActionInfo] {
        return json.actions.values.map({ actionInfoMapper.makeActionInfo(from: $0) })
    }
}
