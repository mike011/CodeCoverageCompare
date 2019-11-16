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
        let row = Row(file: "file", develop: 0, pr: 1)
        XCTAssertEqual(row.change, "💯")
    }

    func testRowPRNotCovered() {
        let row = Row(file: "file", develop: 0, pr: 0)
        XCTAssertEqual(row.change, "🚫")
    }

    func testRowPRCoverageDown() {
        let row = Row(file: "file", develop: 30, pr: 25)
        XCTAssertEqual(row.change, "👎")
    }

    func testRowPRCoverageUp() {
        let row = Row(file: "file", develop: 25, pr: 30)
        XCTAssertEqual(row.change, "👍")
    }

    func testIsTest() {
        let row = Row(file: "Test", develop: 0, pr: 0)
        XCTAssertTrue(row.test)
    }

    func testIsNotTest() {
        let row = Row(file: "file", develop: 0, pr: 0)
        XCTAssertFalse(row.test)
    }

    func testEquals() {
        let row = Row(file: "file", develop: 0, pr: 0)
        let row2 = Row(file: "file", develop: 0, pr: 0)
        XCTAssertTrue(row == row2)
    }

    func testNotEquals() {
        let row = Row(file: "file", develop: 0, pr: 0)
        let row2 = Row(file: "file2", develop: 0, pr: 0)
        XCTAssertFalse(row == row2)
    }

}
