//
//  ComparisonWebPageTests.swift
//  CodeCoverageCompareTests
//
//  Created by Michael Charland on 2021-06-16.
//  Copyright © 2021 Michael Charland. All rights reserved.
//

import XCTest

class ComparisonWebPageTests: XCTestCase {
    func testValidLinks() throws {
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

        XCTAssertEqual(contents.numberOfOccurrencesOf(string: "sourceFile"), 2)
        XCTAssertContains(contents, "www.before.com")
        XCTAssertContains(contents, "www.after.com")
    }

    func testNotBeforeLink() throws {
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

        XCTAssertEqual(contents.numberOfOccurrencesOf(string: "sourceFile"), 1)
        XCTAssertContains(contents, "www.after.com")
    }

    func testNoAfterLink() throws {
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

        XCTAssertEqual(contents.numberOfOccurrencesOf(string: "sourceFile"), 1)
        XCTAssertContains(contents, "www.before.com")
    }

    func testNoLinks() throws {
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

        XCTAssertEqual(contents.numberOfOccurrencesOf(string: "sourceFile"), 0)
    }
}

private extension XCTestCase {
    func XCTAssertContains(
        _ collection: String,
        _ value: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if collection.contains(value) {
            return
        }
        XCTFail("Collection \(collection) does not contain \(value)", file: file, line: line)
    }
}

private extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return components(separatedBy: string).count - 1
    }
}
