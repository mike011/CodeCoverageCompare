//
//  RowTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

@testable import CodeCoverageFramework
import XCTest

class RowTests: XCTestCase {

    func testRowPRAllCovered() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 1)
        XCTAssertEqual(row.change, "💯")
    }

    func testRowPRNotCovered() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        XCTAssertEqual(row.change, "🚫")
    }

    func testRowPRCoverageDown() {
        let row = Row(sourceFile: "file", beforeCoverage: 30, afterCoverage: 25)
        XCTAssertEqual(row.change, "👎")
    }

    func testRowPRCoverageUp() {
        let row = Row(sourceFile: "file", beforeCoverage: 25, afterCoverage: 30)
        XCTAssertEqual(row.change, "👍")
    }

    func testIsTest() {
        let row = Row(sourceFile: "Test", beforeCoverage: 0, afterCoverage: 0)
        XCTAssertTrue(row.test)
    }

    func testIsNotTest() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        XCTAssertFalse(row.test)
    }

    func testEquals() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        let row2 = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        XCTAssertTrue(row == row2)
    }

    func testNotEquals() {
        let row = Row(sourceFile: "file", beforeCoverage: 0, afterCoverage: 0)
        let row2 = Row(sourceFile: "file2", beforeCoverage: 0, afterCoverage: 0)
        XCTAssertFalse(row == row2)
    }

}
