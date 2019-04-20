//
//  CoveredProject.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class CoveredProject {
    var coveredClasses = [String:CoveredClass]()

    func getLinesCovered() -> Int {
        var coverage = 0
        for (_, clazz) in coveredClasses.enumerated() {
            coverage += clazz.value.getLinesCovered()
        }
        return coverage
    }
}
