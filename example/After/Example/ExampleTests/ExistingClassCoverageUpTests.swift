//
//  ExistingClassCoverageUpTests.swift
//  ExampleTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

@testable import Example
import Testing

@Suite struct ExistingClassCoverageUpTests {
    @Test func functionOne() {
        ExistingClassCoverageUp().functionOne()
    }

    @Test func functionTwo() {
        ExistingClassCoverageUp().functionTwo()
    }
}
