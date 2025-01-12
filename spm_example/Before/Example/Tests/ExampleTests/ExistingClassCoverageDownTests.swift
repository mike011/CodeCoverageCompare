//
//  ExistingClassCoverageDroppedTests.swift
//  ExampleTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

@testable import Example
import Testing

@Suite struct ExistingClassCoverageDownTests {
    @Test func functionOne() {
        ExistingClassCoverageDown().functionOne()
    }

    @Test func functionTwo() {
        ExistingClassCoverageDown().functionTwo()
    }
}
