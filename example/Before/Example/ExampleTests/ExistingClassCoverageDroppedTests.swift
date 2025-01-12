//
//  ExistingClassCoverageDroppedTests.swift
//  ExampleTests
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

@testable import Example
import Testing

@Suite struct ExistingClassCoverageDroppedTests {
    @Test func existingClassCoverageDropped() {
        ExistingClassCoverageDropped().existingClassCoverageDropped()
    }
}
