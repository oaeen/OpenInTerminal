//
//  main.swift
//  OpenInTerminal-Lite
//
//  Created by Jianing Wang on 2019/4/19.
//  Copyright © 2019 Jianing Wang. All rights reserved.
//

import Foundation
import OpenInTerminalCore
import Darwin

do {
    let now = Date().timeIntervalSince1970
    let dedupeKey = "OpenInClaudeLastLaunchTimestamp"
    if let lastLaunch = UserDefaults.standard.object(forKey: dedupeKey) as? Double,
       now - lastLaunch < 1.0 {
        exit(0)
    }
    UserDefaults.standard.set(now, forKey: dedupeKey)

    var path = try FinderManager.shared.getPathToFrontFinderWindowOrSelectedFile()
    if path.isEmpty {
        guard let desktopPath = FinderManager.shared.getDesktopPath() else {
            throw OITLError.cannotAccessFinder
        }
        path = desktopPath
    }

    let ghosttyPath = "/Applications/Ghostty.app/Contents/MacOS/ghostty"
    guard FileManager.default.fileExists(atPath: ghosttyPath) else {
        throw OITLError.cannotFindGhostty
    }

    let process = Process()
    process.executableURL = URL(fileURLWithPath: ghosttyPath)
    process.arguments = [
        "--working-directory=\(path)",
        "--command=zsh -lic \"exec claude --dangerously-skip-permissions\"",
    ]
    try process.run()

} catch {
    logw(error.localizedDescription)
}
