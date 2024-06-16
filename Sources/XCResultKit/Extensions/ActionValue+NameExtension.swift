//
//  ActionValue+NameExtension.swift
//
//
//  Created by Nikolai Nobadi on 6/15/24.
//

extension ActionValue {
    /// Extracts the name of the action from the title value.
    var name: String {
        let titleValue = title.value
        if titleValue.contains("Clean") {
            return "Clean"
        }
        if titleValue.contains("Build") {
            return "Build"
        }
        return "Test"
    }
}
