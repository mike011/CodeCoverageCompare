//
//  CoverageComparison.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

public class CoverageComparison {

    let writeLocation: URL
    let before: Project
    let after: Project
    let fileList: [String]

    public init(writeLocation: URL, before: Project, after: Project, fileList: [String]) {
        self.writeLocation = writeLocation
        self.before = before
        self.after = after
        self.fileList = fileList
    }

    func getFilesChanged() -> [Row] {
        var rows = Set<Row>()
        for target in before.targets {
            for beforeFile in target.files {
                let filename = beforeFile.name
                if fileList.contains(filename) || fileList.isEmpty {
                    let beforeCoverage = beforeFile.lineCoverage
                    var afterCoverage: Double?
                    for afterTarget in after.targets {
                        for afterFile in afterTarget.files {
                            if afterFile.name == filename {
                                afterCoverage = afterFile.lineCoverage
                                break
                            }
                        }
                    }
                    rows.insert(Row(sourceFile: filename, beforeCoverage: beforeCoverage, afterCoverage: afterCoverage))
                }
            }
        }

        for target in after.targets {
            for afterFile in target.files {
                let filename = afterFile.name
                if fileList.contains(filename) || fileList.isEmpty {
                    var beforeCoverage: Double?
                    let afterCoverage = afterFile.lineCoverage
                    for beforeTarget in before.targets {
                        for beforeFile in beforeTarget.files {
                            if beforeFile.name == filename {
                                beforeCoverage = beforeFile.lineCoverage
                                break
                            }
                        }
                    }
                    rows.insert(Row(sourceFile: filename, beforeCoverage: beforeCoverage, afterCoverage: afterCoverage))
                }
            }
        }
        var result = Array(rows)
        result.sort(by: { $0.sourceFile < $1.sourceFile })
        return result
    }

    func getRows() -> [Row] {
        return getFilesChanged()
    }

    public func printTable(devLink: String, prLink: String) {
        print("|Change|File|Develop|PR|")
        print("|:----:|----|:-----:|:--:|")

        var sourceRows = [Row]()
        var testRows = [Row]()
        for row in getRows() {
            if row.test {
                testRows.append(row)
            } else {
                sourceRows.append(row)
            }
        }

        sourceRows.sort(by: { $0.sourceFile < $1.sourceFile })
        for row in sourceRows {
            printHTML(row: row, devLink: devLink, prLink: prLink)
        }

        testRows.sort(by: { $0.sourceFile < $1.sourceFile })
        for row in testRows {
            printHTML(row: row, devLink: devLink, prLink: prLink)
        }
    }

    func printHTML(row: Row, devLink: String, prLink: String) {
        //if row.beforeCoverage != row.afterCoverage {
            let end = "_comparison.html"
            let url = writeLocation.appendingPathComponent("\(row.getName())\(end)")
            ComparisonWebPage(row: row, devLink: devLink, prLink: prLink).writeToFile(url: url)
            print(row.toString(baseURL: prLink, end: end))
        //}
    }
}
