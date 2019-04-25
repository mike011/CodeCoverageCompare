//
//  CoveredProject.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class CoveredProject {
    private var coveredClasses = [String:CoveredClass]()

    func add(class clazz: String) {
        coveredClasses[clazz] = CoveredClass(name: clazz)
    }

    func add(lineNumber: Int, hits: Int, toClass clazz: String) {
        coveredClasses[clazz]?.lines.append(CoveredLine(lineNumber: lineNumber, hits: hits))
    }

    func add(coveredClass clazz: CoveredClass) {
        coveredClasses[clazz.name] = clazz
    }

    func getLinesCovered() -> Int {
        var coverage = 0
        for (_, clazz) in coveredClasses.enumerated() {
            coverage += clazz.value.getLinesCovered()
        }
        return coverage
    }

    func getClasses() -> [CoveredClass] {
        return coveredClasses.map { $0.1 }
    }

    func getClass(name: String) -> CoveredClass {
        return coveredClasses[name]
    }
}
