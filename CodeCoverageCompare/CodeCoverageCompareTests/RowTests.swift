//
//  RowTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

import Testing

@Suite struct RowTests {
    // MARK: - Only Before covered

    @Test func coverageBefore100() {
        let row = Row(sourceFile: "file", beforeCoverage: 1, afterCoverage: nil)
        #expect(row.change == "")
    }

    @Test func coverageBeforeNone() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: nil)
        #expect(row.change == "")
    }

    @Test func rowAfterCoverageBefore() {
        let row = Row(sourceFile: "file", beforeCoverage: 30, afterCoverage: nil)
        #expect(row.change == "")
    }

    @Test func virtually100Before() {
        let row = Row(sourceFile: "file", beforeCoverage: 290 / 291, afterCoverage: nil)
        #expect(row.change == "")
    }

    // MARK: - Only After covered

    @Test func coverageAfter100() {
        let row = Row(sourceFile: "file", beforeCoverage: nil, afterCoverage: 1)
        #expect(row.change == "💯")
    }

    @Test func coverageAfterNone() {
        let row = Row(sourceFile: "file", beforeCoverage: nil, afterCoverage: 0)
        #expect(row.change == "🚫")
    }

    @Test func rowAfterCoverageAfter() {
        let row = Row(sourceFile: "file", beforeCoverage: nil, afterCoverage: 30)
        #expect(row.change == "👍")
    }

    @Test func virtually100After() {
        let row = Row(sourceFile: "file", beforeCoverage: nil, afterCoverage: 290 / 291)
        #expect(row.change == "💯")
    }

    // MARK: - Both files covered

    @Test func rowAfterAllCovered() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 1)
        #expect(row.change == "💯")
    }

    @Test func rowAfterNotCovered() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        #expect(row.change == "🚫")
    }

    @Test func rowAfterCoverageDown() {
        let row = Row(sourceFile: "file", beforeCoverage: 30, afterCoverage: 25)
        #expect(row.change == "👎")
    }

    @Test func rowAfterCoverageUp() {
        let row = Row(sourceFile: "file", beforeCoverage: 25, afterCoverage: 30)
        #expect(row.change == "👍")
    }

    @Test func virtually100SlightyHigherAfter() {
        let row = Row(sourceFile: "file", beforeCoverage: 289 / 290, afterCoverage: 290 / 291)
        #expect(row.change == "💯")
    }

    @Test func virtually100SlightyHigherBefore() {
        let row = Row(sourceFile: "file", beforeCoverage: 290 / 291, afterCoverage: 289 / 290)
        #expect(row.change == "💯")
    }

    @Test func lessThenOnePercentChange() {
        let row = Row(sourceFile: "file", beforeCoverage: 900 / 1000, afterCoverage: 904 / 1000)
        #expect(row.change == "")
    }

    @Test func moreThenOnePercentChangeBetter() {
        let row = Row(sourceFile: "file", beforeCoverage: 98 / 100, afterCoverage: 99 / 100)
        #expect(row.change == "👍")
    }

    @Test func moreThenOnePercentChangeWorse() {
        let row = Row(sourceFile: "file", beforeCoverage: 99 / 100, afterCoverage: 98 / 100)
        #expect(row.change == "👎")
    }

    // MARK: - Rest

    @Test func isTest() {
        let row = Row(sourceFile: "Test", beforeCoverage: 0, afterCoverage: 0)
        #expect(row.test)
    }

    @Test func isNotTest() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        #expect(!row.test)
    }

    @Test func equals() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        let row2 = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        #expect(row == row2)
    }

    @Test func notEquals() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        let row2 = Row(sourceFile: "file2", beforeCoverage: 0, afterCoverage: 0)
        #expect(row != row2)
    }

    @Test func getName() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        #expect(row.getName() == "file")
    }

    @Test func getNameWithPeriod() {
        let row = Row(sourceFile: "file.swift", beforeCoverage: 0, afterCoverage: 0)
        #expect(row.getName() == "file")
    }

    @Test func toString() {
        let row = Row(sourceFile: "file.swift", beforeCoverage: 0, afterCoverage: 0)
        #expect(row.toString(parentURL: "http://a.b/", end: ".html") == "|🚫|<a href=http://a.b/file.html>file</a>|0%|0%|")
    }

    @Test func toStringIndex() {
        let row = Row(sourceFile: "index.html", beforeCoverage: 0.1234, afterCoverage: 0.4321)
        #expect(row.toString(parentURL: "http://a.b/", end: ".html") == "|👍|<a href=http://a.b/index.html>Overall</a>|12.34%|43.21%|")
    }

    @Test func toStringNotCovered() {
        let row = Row(sourceFile: "file.swift", beforeCoverage: nil, afterCoverage: nil)
        #expect(row.toString(parentURL: "http://a.b/", end: ".html") == "||<a href=http://a.b/file.html>file</a>|-|-|")
    }

    @Test func toStringOverall() {
        let row = Row(sourceFile: "index", beforeCoverage: 0, afterCoverage: 0)
        #expect(row.toString(parentURL: "http://a.b/", end: ".html") == "|🚫|<a href=http://a.b/index.html>Overall</a>|0.00%|0.00%|")
    }

    @Test func toStringNoParentURL() {
        let row = Row(sourceFile: "index", beforeCoverage: 0, afterCoverage: 0)
        #expect(row.toString(parentURL: nil, end: ".html") == "|🚫|Overall|0.00%|0.00%|")
    }
}
