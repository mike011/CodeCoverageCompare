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
        XCTAssertNil(CodeCoverage().compare(a: cp, b: cp2))
    }
}
