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
    let ignoreList: [String]

    /// Create a new Coverage Comparison instance.
    ///
    /// - Parameters:
    ///   - writeLocation: The file location on the operating system.
    ///   - before: The source code coverage for the project before hand.
    ///   - after: The source code coverage for the project afterwards.
    ///   - fileList: The only files that you care about
    ///   - ignoreList: Files types in glob form that you don't want to see coverage for.
    public init(writeLocation: URL, before: Project?, after: Project, fileList: [String], ignoreList: [String]) {
        self.writeLocation = writeLocation
        if let before = before {
            self.before = before
        } else {
            self.before = Project(
                coveredLines: 0,
                lineCoverage: 0,
                targets: [Target](),
                executableLines: 0
            )
        }
        self.after = after
        self.fileList = fileList
        self.ignoreList = ignoreList
    }

    func getFilesChanged() -> [Row] {
        var rows = Set<Row>()
        var beforeCoveredLines = 0
        var beforeExecutableLines = 0
        for target in before.targets {
            for beforeFile in target.files {
                let filename = beforeFile.name
                if isNotIgnored(file: beforeFile) {
                    beforeCoveredLines += beforeFile.coveredLines
                    beforeExecutableLines += beforeFile.executableLines
                }
                if isValid(file: beforeFile) {
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

        var afterCoveredLines = 0
        var afterExecutableLines = 0
        for target in after.targets {
            for afterFile in target.files {
                let filename = afterFile.name
                if isNotIgnored(file: afterFile) {
                    afterCoveredLines += afterFile.coveredLines
                    afterExecutableLines += afterFile.executableLines
                }
                if isValid(file: afterFile) {
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

        var beforeCoverage = 0.0
        if beforeExecutableLines > 0 {
            beforeCoverage = Double(beforeCoveredLines) / Double(beforeExecutableLines)
        }
        var afterCoverage = 0.0
        if afterExecutableLines > 0 {
            afterCoverage = Double(afterCoveredLines) / Double(afterExecutableLines)
        }

        if afterCoverage != 0.0 {
            result.append(Row(
                sourceFile: "index",
                beforeCoverage: beforeCoverage,
                afterCoverage: afterCoverage
            ))
        }

        return result
    }

    func isFiltered(file: File) -> Bool {
        return fileList.isEmpty || !fileList.filter { file.path.contains($0) }.isEmpty
    }

    func isNotIgnored(file: File) -> Bool {
        if !ignoreList.isEmpty {
            let ignored = ignoreList.filter {
                let regex = try? NSRegularExpression(pattern: $0)
                return regex?.matches(file.path) ?? false
            }
            return ignored.isEmpty
        }
        return true
    }

    func isValid(file: File) -> Bool {
        let result = isFiltered(file: file)
        if result, !ignoreList.isEmpty {
            return isNotIgnored(file: file)
        }
        return result
    }

    public func printTable(beforeLink: String?, afterLink: String?) {
        for line in createTable(rows: getFilesChanged(), beforeLink: beforeLink, afterLink: afterLink) {
            print(line)
        }
    }

    func createTable(rows: [Row], beforeLink: String?, afterLink: String?) -> [String] {
        var printData = [String]()
        guard !rows.isEmpty else {
            return printData
        }
        printData.append("|Change|File|Before|After|")
        printData.append("|:----:|----|:-----:|:--:|")

        var sourceRows = [Row]()
        var testRows = [Row]()
        for row in rows {
            if row.test {
                testRows.append(row)
            } else {
                sourceRows.append(row)
            }
        }

        sourceRows.sort(by: { $0.sourceFile < $1.sourceFile })
        for row in sourceRows {
            printData.append(createHTML(row: row, beforeLink: beforeLink, afterLink: afterLink))
        }

        testRows.sort(by: { $0.sourceFile < $1.sourceFile })
        for row in testRows {
            printData.append(createHTML(row: row, beforeLink: beforeLink, afterLink: afterLink))
        }
        return printData
    }

    private func createHTML(row: Row, beforeLink: String?, afterLink: String?) -> String {
        let end = "_comparison.html"
        var parentURL: String?
        if let afterLink = afterLink {
            let url = writeLocation.appendingPathComponent("\(row.getName())\(end)")
            ComparisonWebPage(row: row, beforeLink: beforeLink, afterLink: afterLink).writeToFile(url: url)
            parentURL = Utils.getParentURL(web: afterLink).absoluteString
        }
        return row.toString(parentURL: parentURL, end: end)
    }
}

private extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
