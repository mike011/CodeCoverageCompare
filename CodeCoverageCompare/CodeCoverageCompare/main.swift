//
//  main.swift
//  CodeCoverageCompare
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import CodeCoverageFramework

let coverage = "//Users/michael/Documents/git/CodeCoverageCompare/example/coverage.json"

let url = URL(fileURLWithPath: coverage)
      let data = try Data(contentsOf: url)
      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
      if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["removedTargets"] as? [Any] {
        print(person)
      }

//CodeCoverage.go(fileA: a, fileB: b)
