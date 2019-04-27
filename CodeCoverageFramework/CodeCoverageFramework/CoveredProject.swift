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

    func getClassNames() -> [String] {
        return coveredClasses.map { $0.1.name }
    }

    func getClass(name: String) -> CoveredClass {
        return coveredClasses[name]!
    }

    func compare(to b: CoveredProject) -> CoveredResult {

        let result = CoveredResult()

        // If the lines match from each project it is very unlikely that tests have been added or removed.
        if getLinesCovered() == b.getLinesCovered() {
            return result
        }
        result.removedClasses = compareClasses(base: self, to: b)
        result.addedClasses = compareClasses(base: b, to: self)

        result.deletedLines = compareChangeInLines(base: self, to: b)
        result.newLines = compareChangeInLines(base: b, to: self)

        return result
    }

    private func compareClasses(base: CoveredProject, to: CoveredProject) -> [CoveredClass] {
        var result = [CoveredClass]()
        for baseName in base.getClassNames() {
            var found = false
            if to.getClassNames().contains(baseName) {
                found = true
                break;
            }
            if !found {
                 result.append(base.getClass(name: baseName))
            }
        }
        return result
    }

    func compareChangeInLines(base: CoveredProject, to: CoveredProject) -> [CoveredClass] {
        var result = [String:CoveredClass]()
        for baseName in base.getClassNames() {
            if to.getClassNames().contains(baseName) {
                for baseLine in base.getClass(name: baseName).lines {
                    if baseLine.hits == 0 {
                        continue
                    }
                    var found = false
                    for toLine in to.getClass(name: baseName).lines {
                        if baseLine == toLine {
                            found = true
                            break
                        }
                    }
                    if !found {
                        if !result.keys.contains(baseName) {
                            result[baseName] = CoveredClass(name: baseName)
                        }
                        result[baseName]!.lines.append(baseLine)
                    }
                }
            }
        }
        return result.map({$0.1})
    }
}
