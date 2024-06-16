//
//  CIResultManager.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import Foundation

/// `CIResultManager` manages the extraction of CI results from an XCResult file.
public struct CIResultManager {
    let shell: Shell
    let actionInfoMapper = ActionInfoMapper.self
    let testResultMapper = TestResultMapper.self
}

// MARK: - Init
public extension CIResultManager {
    /// Initializes a new `CIResultManager` with a default `ShellAdapter`.
    init() {
        self.init(shell: ShellAdapter())
    }
}

// MARK: - Actions
public extension CIResultManager {
    /// Extracts CI results from an XCResult file.
    /// - Parameter xcresultPath: The path to the XCResult file.
    /// - Returns: A `CIResult` object containing the extracted results, or `nil` if extraction fails.
    func extractResults(xcresultPath: String) -> CIResult? {
        guard let result = getResultJSON(path: xcresultPath) else { return nil }
        
        let actions = makeActionInfoList(result)
        let testResult = testResultMapper.makeTestResult(result)
        
        return .init(actions: actions, testResult: testResult)
    }
}

// MARK: - Private Methods
private extension CIResultManager {
    /// Retrieves the JSON representation of the XCResult file.
    /// - Parameter path: The path to the XCResult file.
    /// - Returns: An `XCResultJSON` object, or `nil` if parsing fails.
    func getResultJSON(path: String) -> XCResultJSON? {
        let output = shell.runCommand("xcrun xcresulttool get --path \(path) --format json")
        
        guard let jsonData = output.data(using: .utf8) else { return nil }
        
        return try? JSONDecoder().decode(XCResultJSON.self, from: jsonData)
    }
    
    /// Creates a list of `CIActionInfo` from the parsed XCResult JSON.
    /// - Parameter json: The parsed `XCResultJSON`.
    /// - Returns: A list of `CIActionInfo` objects.
    func makeActionInfoList(_ json: XCResultJSON) -> [CIActionInfo] {
        return json.actions.values.map({ actionInfoMapper.makeActionInfo(from: $0) })
    }
}

// MARK: - Dependencies
/// Protocol defining the shell command interface.
protocol Shell {
    /// Runs a shell command and returns the standard output.
    /// - Parameter command: The shell command to run.
    /// - Returns: The standard output of the shell command.
    func runCommand(_ command: String) -> String
}
