//
//  CodeCoverage.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

public class CodeCoverage {

    public static func go(fileA: String, fileB: String) {
        let projectA = Parser(withFileName:fileA).project
        let projectB = Parser(withFileName:fileB).project
        //CodeCoverage().compare(base: projectA, compareTo: projectB)
    }

    func compare(base: CoveredProject, compareTo b: CoveredProject) -> CoveredProject? {

        // If the lines match from each project it is very unlikely that tests have been added or removed.
        if base.getLinesCovered() == b.getLinesCovered() {
            return nil
        }

        let diff = CoveredProject()
        for baseCoveredClass in base.getClasses() {
            if !b.getClasses().contains(baseCoveredClass) {
                diff.add(coveredClass: baseCoveredClass)
            } else {
                for line in b.getClass(name: baseCoveredClass.name).lines {
                    for baseLine in baseCoveredClass.lines {
                        if line == baseLine {
                            
                        }
                    }
                }

            }
        }

        for baseFile in b.getClasses() {
            if !base.getClasses().contains(baseFile) {
                
                diff.add(coveredClass: baseFile)
            }
        }
        return diff
    }
}
