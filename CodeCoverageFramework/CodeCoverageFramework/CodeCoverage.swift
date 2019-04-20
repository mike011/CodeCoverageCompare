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
        //CodeCoverage().compare(a: projectA, b: projectB)
    }

    func compare(a: CoveredProject, b: CoveredProject) -> CoveredProject? {

        // If the lines match from each project it is very unlikely that tests have been added or removed.
        if a.getLinesCovered() == b.getLinesCovered() {
            return nil
        }

        let diff = CoveredProject()
        return diff
    }
}
