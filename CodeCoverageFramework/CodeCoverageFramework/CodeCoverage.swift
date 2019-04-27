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
        let result = projectA.compare(to: projectB)
        CodeCoverage().printTextReport(from: result)
    }

    func printTextReport(from: CoveredResult) {
        from.addedClasses.printElements(withTitle: "Classes Added")
        from.removedClasses.printElements(withTitle: "Classes Removed")
        from.deletedLines.printElements(withTitle: "Lines Removed")
        from.newLines.printElements(withTitle: "Lines Added")
    }
}

extension Array where Element == CoveredClass  {
    func printElements(withTitle title: String) {
        if !self.isEmpty {
            print(title)
            for clazz in self {
                print(clazz.name)
                for line in clazz.lines {
                    print("\t \(line)")
                }
            }
        }
    }
}
