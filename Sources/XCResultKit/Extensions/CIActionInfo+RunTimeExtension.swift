//
//  CIActionInfo+RunTimeExtension.swift
//
//
//  Created by Nikolai Nobadi on 6/15/24.
//

/// Extension to add a computed property to `CIActionInfo` for formatting the run time.
public extension CIActionInfo {
    /// A computed property that returns the run time as a formatted string.
    /// - Returns: A formatted string representing the run time, or `nil` if `timeInterval` is not available.
    var runTime: String? {
        guard let timeInterval else { return nil }
        
        return Int(timeInterval).formattedString
    }
}

