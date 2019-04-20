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
        cp.add(class: "dog")
        cp.add(lineNumber: 21, hits: 0, toClass: "dog")
        XCTAssertEqual(1, cp.getLinesCovered())
    }

    func testGetCoverageMultipleFiles() {
        let cp = CoveredProject()
        cp.add(class: "dog")
        cp.add(lineNumber: 21, hits: 0, toClass: "dog")
        cp.add(class: "cat")
        cp.add(lineNumber: 20, hits: 0, toClass: "cat")
        XCTAssertEqual(2, cp.getLinesCovered())
    }
}
