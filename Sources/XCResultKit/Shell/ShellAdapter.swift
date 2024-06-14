//
//  ShellAdapter.swift
//
//
//  Created by Nikolai Nobadi on 6/14/24.
//

import SwiftShell

struct ShellAdapter: Shell {
    func runCommand(_ command: String) -> String {
        return run(bash: command).stdout
    }
}
