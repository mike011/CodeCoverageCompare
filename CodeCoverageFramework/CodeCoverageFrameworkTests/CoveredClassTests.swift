//
//  CoveredClassTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import CodeCoverageFramework

class CoveredClassTests: XCTestCase {

    func testEmptyFileHasNoCoverage() {
        let cc = CoveredClass(name: "File")
        XCTAssertEqual(0, cc.getLinesCovered())
    }

    func testGetCoverageOneFile() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 25, hits: 1))
        XCTAssertEqual(1, cc.getLinesCovered())
    }

    func testGetCoverageOneFileNoLinesHit() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 25, hits: 0))
        XCTAssertEqual(0, cc.getLinesCovered())
    }

    func testGetCoverageMultipeFiles() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 25, hits: 1))
        cc.lines.append(CoveredLine(lineNumber: 13, hits: 2))
        XCTAssertEqual(2, cc.getLinesCovered())
    }

    func testCompareSameObject() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 25, hits: 1))
        XCTAssertNil(cc.compare(to:cc))
    }

    func testCompareDifferentObjectSameFileAndCoverage() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 25, hits: 1))

        let cc2 = CoveredClass(name: "File")
        cc2.lines.append(CoveredLine(lineNumber: 25, hits: 1))
        XCTAssertNil(cc.compare(to:cc))
    }

    func testEqualsDifferentNames() {
        let cc = CoveredClass(name: "File")
        let cc2 = CoveredClass(name: "File2")
        XCTAssertNotEqual(cc, cc2)
    }

    func testEqualsDifferentOfFiles() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 24, hits: 1))
        let cc2 = CoveredClass(name: "File")
        XCTAssertNotEqual(cc, cc2)
    }

    func testEqualsSame() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 24, hits: 1))
        let cc2 = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 24, hits: 1))
        XCTAssertNotEqual(cc, cc2)
    }

    func testCompareOneLineAdded() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 24, hits: 1))

        let cc2 = CoveredClass(name: "File")
        cc2.lines.append(CoveredLine(lineNumber: 24, hits: 1))
        cc2.lines.append(CoveredLine(lineNumber: 25, hits: 1))

        let diff = cc.compare(to:cc2)
        XCTAssertNil(diff)

        let cc3 = CoveredClass(name: "File")
        cc3.lines.append(CoveredLine(lineNumber: 25, hits: 1))
        XCTAssertEqual(diff, cc3)
    }
}
