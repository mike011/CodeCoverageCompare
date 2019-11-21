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
    let file: String
    let beforeCoverage: Double
    let afterCoverage: Double
    var test: Bool {
        return file.contains("Test")
    }

    func toString(baseURL: String) -> String {
        let name = getLink(baseURL: baseURL)
        return "|\(change)|\(name)|\(getPercentage(beforeCoverage))|\(getPercentage(afterCoverage))|"
    }

    private func getPercentage(_ value: Double) -> String {
          return String(format: "%.0f", value * 100) + "%"
      }

    private func getLink(baseURL: String) -> String {
        let name = getName()
        let url = "\(baseURL)/\(name).html"
        return "<a href=\(url)>\(name)%</a>"
    }

    func getName() -> String {
        var name = file
          if let period = file.firstIndex(of: ".") {
              name = file.substring(to: period)
          }
        return name
    }
}

extension Row: Hashable {
    static func == (lhs: Row, rhs: Row) -> Bool {
        return lhs.file == rhs.file
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(file)
    }
}
