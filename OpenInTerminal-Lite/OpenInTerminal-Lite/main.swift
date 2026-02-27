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

    // `clear` keeps the launch command from staying visible in the terminal.
    let command = "cd \(path.terminalPathEscaped()); clear; claude --dangerously-skip-permissions"
    let source = """
    tell application "Terminal"
        activate
        do script "\(command)"
    end tell
    """
    guard let script = NSAppleScript(source: source) else {
        throw OITLError.cannotCreateAppleScript
    }
    var error: NSDictionary?
    script.executeAndReturnError(&error)
    if error != nil {
        throw OITLError.cannotAccessTerminal
    }

} catch {
    logw(error.localizedDescription)
}
