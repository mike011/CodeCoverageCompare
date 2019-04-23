//
//  CoveredLine.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

struct CoveredLine: Equatable {
    var lineNumber: Int
    var hits: Int

    static func == (lhs: CoveredLine, rhs: CoveredLine) -> Bool {
        if (lhs.lineNumber == rhs.lineNumber) &&
            ((lhs.hits == 0 && rhs.hits == 0) || (lhs.hits > 0 && rhs.hits > 0)) {
            return true
        }
        return false
    }
}
