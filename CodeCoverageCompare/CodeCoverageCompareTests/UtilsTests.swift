//
//  UtilsTests.swift
//  CodeCoverageCompareTests
//
//  Created by Michael Charland on 2019-12-01.
//  Copyright © 2019 Michael Charland. All rights reserved.
//

import XCTest

class UtilsTests: XCTestCase {

    func testGetParentFileNameWithSlashReturnsFolder() {
        XCTAssertEqual(Utils.getParentURL(file: "a/b.json").absoluteString, URL(fileURLWithPath: "a").absoluteString + "/")
    }

    func testGetParentFileForURL() {
        XCTAssertEqual(Utils.getParentURL(web: "http://www.nba.com/b.json").absoluteString, URL(string:"http://www.nba.com/")?.absoluteURL.absoluteString)
    }

    func testFromGlobLines() {
        var globLines = [String]()
        globLines.append("a")
        globLines.append("*Pod*")
        globLines.append("UI*+*.swift")

        let result = Utils.convertToRegex(fromGlobLines: globLines)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], "a")
        XCTAssertEqual(result[1], ".*Pod.*")
        XCTAssertEqual(result[2], "UI.*+.*.swift")
    }
}
