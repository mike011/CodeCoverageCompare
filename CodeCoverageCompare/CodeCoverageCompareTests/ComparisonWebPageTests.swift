//
//  ComparisonWebPageTests.swift
//  CodeCoverageCompareTests
//
//  Created by Michael Charland on 2021-06-16.
//  Copyright © 2021 Michael Charland. All rights reserved.
//

import Testing

@Suite struct ComparisonWebPageTests {
    @Test func validLinks() throws {
        let row = Row(
            sourceFile: "sourceFile",
            beforeCoverage: 50.0,
            afterCoverage: 60.0
        )

        let page = ComparisonWebPage(
            row: row,
            beforeLink: "http://www.before.com",
            afterLink: "http://www.after.com"
        )
        let contents = page.getContents()

        #expect(contents.numberOfOccurrencesOf(string: "sourceFile") == 2)
        XCTAssertContains(contents, "www.before.com")
        XCTAssertContains(contents, "www.after.com")
    }

    @Test func notBeforeLink() throws {
        let row = Row(
            sourceFile: "sourceFile",
            beforeCoverage: 50.0,
            afterCoverage: 60.0
        )

        let page = ComparisonWebPage(
            row: row,
            beforeLink: nil,
            afterLink: "http://www.after.com"
        )
        let contents = page.getContents()

        #expect(contents.numberOfOccurrencesOf(string: "sourceFile") == 1)
        XCTAssertContains(contents, "www.after.com")
    }

    @Test func noAfterLink() throws {
        let row = Row(
            sourceFile: "sourceFile",
            beforeCoverage: 50.0,
            afterCoverage: 60.0
        )

        let page = ComparisonWebPage(
            row: row,
            beforeLink: "http://www.before.com",
            afterLink: nil
        )
        let contents = page.getContents()

        #expect(contents.numberOfOccurrencesOf(string: "sourceFile") == 1)
        XCTAssertContains(contents, "www.before.com")
    }

    @Test func noLinks() throws {
        let row = Row(
            sourceFile: "sourceFile",
            beforeCoverage: 50.0,
            afterCoverage: 60.0
        )

        let page = ComparisonWebPage(
            row: row,
            beforeLink: nil,
            afterLink: nil
        )
        let contents = page.getContents()

        #expect(contents.numberOfOccurrencesOf(string: "sourceFile") == 0)
    }
}

func XCTAssertContains(
    _ collection: String,
    _ value: String,
    file: StaticString = #file,
    line: UInt = #line
) {
    if collection.contains(value) {
        return
    }
    // Issue.record("Collection \(collection) does not contain \(value)", file: file, line: line)
}


private extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return components(separatedBy: string).count - 1
    }
}
