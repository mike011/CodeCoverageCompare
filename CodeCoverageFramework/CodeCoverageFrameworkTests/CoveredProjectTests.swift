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
        cp.add(lineNumber: 21, hits: 1, toClass: "dog")
        XCTAssertEqual(1, cp.getLinesCovered())
    }

    func testGetCoverageMultipleFiles() {
        let cp = CoveredProject()
        cp.add(class: "dog")
        cp.add(lineNumber: 21, hits: 1, toClass: "dog")
        cp.add(class: "cat")
        cp.add(lineNumber: 20, hits: 1, toClass: "cat")
        XCTAssertEqual(2, cp.getLinesCovered())
    }

    func testEmptyProjectsHaveNoDifferences() {
        let cp = CoveredProject()
        let cp2 = CoveredProject()
        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 0)
        XCTAssertEqual(result.deletedLines.count, 0)
        XCTAssertEqual(result.coveredLines.count, 0)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    // MARK: - compare tests

    func testOneNewFile() {
        let cp = CoveredProject()
        let cp2 = CoveredProject()
        cp2.add(class: "donkey")
        cp2.add(lineNumber: 21, hits: 1, toClass: "donkey")

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 1)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 0)
        XCTAssertEqual(result.deletedLines.count, 0)
        XCTAssertEqual(result.coveredLines.count, 0)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    func testOneFileRemoved() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 21, hits: 1, toClass: "donkey")
        let cp2 = CoveredProject()

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 1)
        XCTAssertEqual(result.newLines.count, 0)
        XCTAssertEqual(result.deletedLines.count, 0)
        XCTAssertEqual(result.coveredLines.count, 0)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    func testOneLineAdded() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 21, hits: 1, toClass: "donkey")

        let cp2 = CoveredProject()
        cp2.add(class: "donkey")
        cp2.add(lineNumber: 21, hits: 1, toClass: "donkey")
        cp2.add(lineNumber: 22, hits: 1, toClass: "donkey")

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 1)
        XCTAssertEqual(result.newLines[0].getLinesCovered(), 1)
        XCTAssertEqual(result.deletedLines.count, 0)
        XCTAssertEqual(result.coveredLines.count, 0)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    func testTwoLinesAdded() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 21, hits: 1, toClass: "donkey")

        let cp2 = CoveredProject()
        cp2.add(class: "donkey")
        cp2.add(lineNumber: 21, hits: 1, toClass: "donkey")
        cp2.add(lineNumber: 22, hits: 1, toClass: "donkey")
        cp2.add(lineNumber: 23, hits: 5, toClass: "donkey")

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 1)
        XCTAssertEqual(result.newLines[0].getLinesCovered(), 2)
        XCTAssertEqual(result.deletedLines.count, 0)
        XCTAssertEqual(result.coveredLines.count, 0)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    func testOneLineRemoved() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 22, hits: 1, toClass: "donkey")
        cp.add(lineNumber: 23, hits: 1, toClass: "donkey")

        let cp2 = CoveredProject()
        cp2.add(class: "donkey")
        cp2.add(lineNumber: 22, hits: 1, toClass: "donkey")

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 0)
        XCTAssertEqual(result.deletedLines.count, 1)
        XCTAssertEqual(result.deletedLines[0].getLinesCovered(), 1)
        XCTAssertEqual(result.coveredLines.count, 0)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    func testTwoLinesRemoved() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 22, hits: 1, toClass: "donkey")
        cp.add(lineNumber: 23, hits: 5, toClass: "donkey")
        cp.add(lineNumber: 24, hits: 5, toClass: "donkey")

        let cp2 = CoveredProject()
        cp2.add(class: "donkey")
        cp2.add(lineNumber: 24, hits: 5, toClass: "donkey")

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 0)
        XCTAssertEqual(result.deletedLines.count, 1)
        XCTAssertEqual(result.deletedLines[0].getLinesCovered(), 2)
        XCTAssertEqual(result.coveredLines.count, 0)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    func testLineNowCovered() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 22, hits: 0, toClass: "donkey")

        let cp2 = CoveredProject()
        cp2.add(class: "donkey")
        cp2.add(lineNumber: 22, hits: 1, toClass: "donkey")

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 0)
        XCTAssertEqual(result.deletedLines.count, 0)
        XCTAssertEqual(result.coveredLines.count, 1)
        //XCTAssertEqual(result.coveredLines[0].getLinesCovered(), 1)
        XCTAssertEqual(result.notCoveredLines.count, 0)
    }

    func testLineNowNotCovered() {
        let cp = CoveredProject()
        cp.add(class: "donkey")
        cp.add(lineNumber: 22, hits: 1, toClass: "donkey")

        let cp2 = CoveredProject()
        cp2.add(class: "donkey")
        cp2.add(lineNumber: 22, hits: 0, toClass: "donkey")

        let result = cp.compare(to: cp2)
        XCTAssertEqual(result.addedClasses.count, 0)
        XCTAssertEqual(result.removedClasses.count, 0)
        XCTAssertEqual(result.newLines.count, 0)
        XCTAssertEqual(result.deletedLines.count, 0)
        XCTAssertEqual(result.coveredLines.count, 1)
        XCTAssertEqual(result.notCoveredLines.count, 1)
        //XCTAssertEqual(result.notCoveredLines[0].getLinesCovered(), 1)
    }
}
