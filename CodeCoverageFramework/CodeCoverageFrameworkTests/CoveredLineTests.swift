//
//  CoveredLineTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import CodeCoverageFramework

class CoveredLineTests: XCTestCase {

    func testCompareSame() {

        let line1 = CoveredLine(lineNumber: 1, hits: 2)
        let line2 = CoveredLine(lineNumber: 1, hits: 1)

        XCTAssertEqual(line1, line2)
    }

    func testCompareFirstNoLinesCovered() {

        let line1 = CoveredLine(lineNumber: 1, hits: 0)
        let line2 = CoveredLine(lineNumber: 1, hits: 2)

        XCTAssertNotEqual(line1, line2)
    }

    func testCompareSecondNoLinesCovered() {

        let line1 = CoveredLine(lineNumber: 1, hits: 2)
        let line2 = CoveredLine(lineNumber: 1, hits: 0)

        XCTAssertNotEqual(line1, line2)
    }

    func testCompareBothNoLinesCovered() {

        let line1 = CoveredLine(lineNumber: 1, hits: 0)
        let line2 = CoveredLine(lineNumber: 1, hits: 0)

        XCTAssertEqual(line1, line2)
    }

    func testCompareDifferentLines() {

        let line1 = CoveredLine(lineNumber: 2, hits: 2)
        let line2 = CoveredLine(lineNumber: 1, hits: 3)

        XCTAssertNotEqual(line1, line2)
    }

    func testCompareNegativeVsPostive() {

        let line1 = CoveredLine(lineNumber: 2, hits: 2)
        let line2 = CoveredLine(lineNumber: 2, hits: -1)

        XCTAssertNotEqual(line1, line2)
    }

    func testCompareBothNegative() {

        let line1 = CoveredLine(lineNumber: 2, hits: -1)
        let line2 = CoveredLine(lineNumber: 2, hits: -1)

        XCTAssertEqual(line1, line2)
    }
}
