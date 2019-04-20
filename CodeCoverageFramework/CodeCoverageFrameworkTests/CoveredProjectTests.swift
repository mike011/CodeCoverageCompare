//
//  CoveredProjectTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import CodeCoverageFramework

class CoveredProjectTests: XCTestCase {

    func testGetCoverageEmpty() {
        let cp = CoveredProject()
        XCTAssertEqual(0, cp.getLinesCovered())
    }

    func testGetCoverageOneFile() {
        let cp = CoveredProject()
        cp.coveredClasses["dog"] = CoveredClass(name: "dog")
        cp.coveredClasses["dog"]?.lines.append(CoveredLine(line: 21, hits: 0))
        XCTAssertEqual(21, cp.getLinesCovered())
    }

    func testGetCoverageMultipleFiles() {
        let cp = CoveredProject()
        cp.coveredClasses["dog"] = CoveredClass(name: "dog")
        cp.coveredClasses["dog"]?.lines.append(CoveredLine(line: 21, hits: 0))
        cp.coveredClasses["cat"] = CoveredClass(name: "cat")
        cp.coveredClasses["cat"]?.lines.append(CoveredLine(line: 20, hits: 0))
        XCTAssertEqual(41, cp.getLinesCovered())
    }
}
