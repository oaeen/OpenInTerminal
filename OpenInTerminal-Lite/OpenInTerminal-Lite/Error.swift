//
//  Error.swift
//  OpenInTerminal-Lite
//
//  Created by Jianing Wang on 2019/4/21.
//  Copyright © 2019 Jianing Wang. All rights reserved.
//

import Foundation

enum OITLError: Error {
    
    case cannotGetTerminal
    case cannotAccessFinder
    case cannotFindGhostty
    
}

extension OITLError : CustomStringConvertible {
    
    var description: String {
        
        switch self {
            
        case .cannotGetTerminal:
            return "There is no default terminal. And user did not pick a terminal"
        case .cannotAccessFinder:
            return "Cannot access Finder, please check permissions."
        case .cannotFindGhostty:
            return "Cannot find Ghostty at /Applications/Ghostty.app."
        }
    }
}
