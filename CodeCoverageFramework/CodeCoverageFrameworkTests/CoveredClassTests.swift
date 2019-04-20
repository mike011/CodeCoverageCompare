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
        cc.lines.append(CoveredLine(lineNumber: 25, hits: 0))
        XCTAssertEqual(1, cc.getLinesCovered())
    }

    func testGetCoverageMultipeFiles() {
        let cc = CoveredClass(name: "File")
        cc.lines.append(CoveredLine(lineNumber: 25, hits: 0))
        cc.lines.append(CoveredLine(lineNumber: 13, hits: 0))
        XCTAssertEqual(2, cc.getLinesCovered())
    }
}
