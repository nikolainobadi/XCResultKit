//
//  ShellAdapter.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import SwiftShell

/// `ShellAdapter` conforms to the `Shell` protocol and provides a method to run shell commands.
struct ShellAdapter: Shell {
    /// Runs a shell command using SwiftShell and returns the standard output.
    /// - Parameter command: The shell command to run.
    /// - Returns: The standard output of the shell command.
    func runCommand(_ command: String) -> String {
        return run(bash: command).stdout
    }
}
