//
//  main.swift
//  CodeCoverageCompare
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import CodeCoverageFramework

func loadCoverageFile(file: String) -> Project {

    let url = URL(fileURLWithPath: file)
    let json = try! Data(contentsOf: url)

    let decoder = JSONDecoder()
    return try! decoder.decode(Project.self, from: json)
}

struct Row {
    var change: String {
        var change = ""
        if(develop > pr) {
           change = "▼"
        } else if(pr > develop) {
           change = "▲"
        }
        return change
    }
    let file: String
    let develop: Double
    let pr: Double

    func toString() -> String {
        return "|\(change)|\(file)|\(develop)|\(pr)|"
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

func getFilesChanged(before: Project, after: Project) -> Set<Row> {
    var rows = Set<Row>()
    for beforeFile in before.targets.first!.files {
        let filename = beforeFile.name
        let beforeCoverage = beforeFile.lineCoverage
        var afterCoverage = 0.0
        for afterFile in after.targets.first!.files {
            if afterFile.name == filename {
                afterCoverage = afterFile.lineCoverage
                break
            }
        }
        rows.insert(Row(file: filename, develop: beforeCoverage, pr: afterCoverage))
    }

    for afterFile in after.targets.first!.files {
        let filename = afterFile.name
        var beforeCoverage = 0.0
        let afterCoverage = afterFile.lineCoverage
        for beforeFile in before.targets.first!.files {
            if beforeFile.name == filename {
                beforeCoverage = beforeFile.lineCoverage
                break
            }
        }
       // rows.insert(Row(file: filename, develop: beforeCoverage, pr: afterCoverage))
    }
    return rows
}

func getRows(before: Project, after: Project) -> Set<Row> {
    return getFilesChanged(before: before, after: after)
}

func printTable(before: Project, after: Project) {
    print("|Change|File|Develop|PR|")
    print("|------|----|-------|--|")
    for row in getRows(before: before, after: after) {
        print(row.toString())
    }
}

let before = "//Users/michael/Documents/git/CodeCoverageCompare/example/before.json"
let after = "//Users/michael/Documents/git/CodeCoverageCompare/example/after.json"

printTable(before: loadCoverageFile(file: before), after: loadCoverageFile(file: after))

func compare() throws {
    let coverage = "//Users/michael/Documents/git/CodeCoverageCompare/example/coverage.json"

    let url = URL(fileURLWithPath: coverage)
    let data = try Data(contentsOf: url)
    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
    if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["removedTargets"] as? [Any] {
    print(person)
    }
}

//CodeCoverage.go(fileA: a, fileB: b)

