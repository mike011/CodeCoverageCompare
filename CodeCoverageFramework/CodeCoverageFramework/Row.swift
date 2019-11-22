//
//  Row.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

struct Row {
    var change: String {
        var change = ""
        if afterCoverage == 1 {
            change = "💯"
        } else if afterCoverage == 0 {
            change = "🚫"
        } else if(beforeCoverage > afterCoverage) {
           change = "👎"
        } else if(afterCoverage > beforeCoverage) {
           change = "👍"
        }
        return change
    }
    let sourceFile: String
    let beforeCoverage: Double
    let afterCoverage: Double
    var test: Bool {
        return sourceFile.contains("Test")
    }

    func toString(baseURL: String, end: String) -> String {
        let name = getLink(baseURL: baseURL, withEnd: end)
        return "|\(change)|\(name)|\(getPercentage(beforeCoverage))|\(getPercentage(afterCoverage))|"
    }

    private func getPercentage(_ value: Double) -> String {
          return String(format: "%.0f", value * 100) + "%"
      }

    private func getLink(baseURL: String, withEnd end: String) -> String {
        let name = getName()
        let url = "\(baseURL)/\(name)\(end)"
        return "<a href=\(url)>\(name)</a>"
    }

    func getName() -> String {
        var name = sourceFile
          if let period = sourceFile.firstIndex(of: ".") {
              name = sourceFile.substring(to: period)
          }
        return name
    }
}

extension Row: Hashable {
    static func == (lhs: Row, rhs: Row) -> Bool {
        return lhs.sourceFile == rhs.sourceFile
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(sourceFile)
    }
}
