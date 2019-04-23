//
//  CodeCoverageTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import CodeCoverageFramework

class CodeCoverageTests: XCTestCase {

    func testEmptyProjectsHaveNoDifferences() {
        let cp = CoveredProject()
        let cp2 = CoveredProject()
        XCTAssertNil(CodeCoverage().compare(base: cp, compareTo: cp2))
    }

    func testOneNewFileAdded() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 30, hits: 1, toClass: "donkey")
        let cp2 = CoveredProject()

        let result = CodeCoverage().compare(base: cp, compareTo: cp2)
        XCTAssertNotNil(result)

    }
}
