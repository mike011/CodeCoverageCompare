//
//  main.swift
//  CodeCoverageCompare
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import CodeCoverageFramework

let a = "//Users/michael/Documents/git/CodeCoverageCompare/example/coverageA.xml"
let b = "//Users/michael/Documents/git/CodeCoverageCompare/example/coverageB.xml"

CodeCoverage.go(fileA: a, fileB: b)

print("Hello, World!")

