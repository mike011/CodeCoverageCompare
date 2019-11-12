//
//  CoverageComparison.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

public class CoverageComparison {

    let before: Project
    let after: Project

    public init(before: Project, after: Project) {
        self.before = before
        self.after = after
    }

    func getFilesChanged() -> Set<Row> {
        var rows = Set<Row>()
        for target in before.targets {
            for beforeFile in target.files {
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
        }

        for target in after.targets {
            for afterFile in target.files {
                let filename = afterFile.name
                var beforeCoverage = 0.0
                let afterCoverage = afterFile.lineCoverage
                for beforeFile in before.targets.first!.files {
                    if beforeFile.name == filename {
                        beforeCoverage = beforeFile.lineCoverage
                        break
                    }
                }

                rows.insert(Row(file: filename, develop: beforeCoverage, pr: afterCoverage))
            }
        }
        return rows
    }

    func getRows() -> Set<Row> {
        return getFilesChanged()
    }

    public func printTable(devLink: String, prLink: String) {
        print("|Change|File|Develop|PR|")
        print("|------|----|-------|--|")

        var sourceRows = [Row]()
        var testRows = [Row]()
        for row in getRows() {
            if row.test {
                testRows.append(row)
            } else {
                sourceRows.append(row)
            }
        }

        sourceRows.sort(by: { $0.file > $1.file })
        for row in sourceRows {
            print(row.toString(devLink: devLink, prLink: prLink))
        }

        testRows.sort(by: { $0.file > $1.file })
        for row in testRows {
            print(row.toString(devLink: devLink, prLink: prLink))
        }
    }
}
