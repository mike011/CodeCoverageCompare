//
//  CoveredClass.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class CoveredClass: Equatable {

    var name: String
    var lines = [CoveredLine]()

    init(name: String) {
        self.name = name
    }

    func getLinesCovered() -> Int {
        return lines.reduce(0, {
            if $1.hits > 0 {
                return $0 + 1
            }
            return $0
        })
    }

    static func == (lhs: CoveredClass, rhs: CoveredClass) -> Bool {
        if lhs.name != rhs.name {
            return false
        }

        if lhs.lines.count != rhs.lines.count {
            return false
        }

        for i in 0 ..< lhs.lines.count {
            if lhs.lines[i] != rhs.lines[i] {
                return false
            }
        }
        return true
    }

    func compare(to: CoveredClass) -> CoveredClass? {

        if self.name != to.name {
            return nil
        }

        var result = CoveredClass(name: self.name)

        return result
    }
}
