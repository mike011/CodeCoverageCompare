//
//  CoverageCompareTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

@testable import CodeCoverageFramework
import XCTest

class CoverageCompareTests: XCTestCase {

    // MARK: - Single File Covered

    func testCoverageAdded() {
        let before = createProject(coverage: 0.3)
        let after = createProject(coverage: 0.5)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after)

        let rows = cc.getFilesChanged()
        XCTAssertFalse(rows.isEmpty)
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(rows.first!.sourceFile, "name")
        XCTAssertEqual(rows.first!.beforeCoverage, 0.3)
        XCTAssertEqual(rows.first!.afterCoverage, 0.5)
        XCTAssertFalse(rows.first!.test)
    }

    func createProject(coverage: Double) -> Project {
        var files = [File]()
        files.append(File(coveredLines: 0, lineCoverage: coverage, path: "", functions: [Function](), name: "name", executableLines: 0))
        var targets = [Target]()
        targets.append(Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: ""))
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // MARK: - Multiple files

    func testCoverageAddedForMultipleFiles() {
        let before = createProjectWithMultipleFiles(coverageA: 0.2, coverageB: 0.9)
        let after = createProjectWithMultipleFiles(coverageA: 0.1, coverageB: 0.92)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after)

        let rows = cc.getFilesChanged()

        XCTAssertFalse(rows.isEmpty)
        XCTAssertEqual(rows.count, 2)

        XCTAssertEqual(rows[0].sourceFile, "name")
        XCTAssertEqual(rows[0].beforeCoverage, 0.2)
        XCTAssertEqual(rows[0].afterCoverage, 0.1)
        XCTAssertFalse(rows[0].test)

        XCTAssertEqual(rows[1].sourceFile, "name2")
        XCTAssertEqual(rows[1].beforeCoverage, 0.9)
        XCTAssertEqual(rows[1].afterCoverage, 0.92)
        XCTAssertFalse(rows[1].test)
    }

    func createProjectWithMultipleFiles(coverageA: Double, coverageB: Double) -> Project {
        var files = [File]()
        files.append(File(coveredLines: 0, lineCoverage: coverageA, path: "", functions: [Function](), name: "name", executableLines: 0))
        files.append(File(coveredLines: 0, lineCoverage: coverageB, path: "", functions: [Function](), name: "name2", executableLines: 0))
        var targets = [Target]()
        targets.append(Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: ""))
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // MARK: - Different Targets with Coverage

    func testCoverageAddedToSeperateTarget() {
        let before = createProjectWithTargets(nameA: "name", coverageA: 0.23, nameB: "testName", coverageB: 0.92)
        let after = createProjectWithTargets(nameA: "name", coverageA: 0.22, nameB: "testName", coverageB: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after)

        let rows = cc.getFilesChanged()

        XCTAssertFalse(rows.isEmpty)
        XCTAssertEqual(rows.count, 2)

        XCTAssertEqual(rows[0].sourceFile, "name")
        XCTAssertEqual(rows[0].beforeCoverage, 0.23)
        XCTAssertEqual(rows[0].afterCoverage, 0.22)
        XCTAssertFalse(rows[0].test)

        XCTAssertEqual(rows[1].sourceFile, "testName")
        XCTAssertEqual(rows[1].beforeCoverage, 0.92)
        XCTAssertEqual(rows[1].afterCoverage, 0.91)
        XCTAssertFalse(rows[1].test)
    }

    func testCoverageAddedToSeperateTargetFlip() {
        let before = createProjectWithTargets(nameA: "name", coverageA: 0.23, nameB: "testName", coverageB: 0.92)
        let after = createProjectWithTargets(nameA: "testName", coverageA: 0.22, nameB: "name", coverageB: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after)

        let rows = cc.getFilesChanged()

        XCTAssertFalse(rows.isEmpty)
        XCTAssertEqual(rows.count, 2)

        XCTAssertEqual(rows[0].sourceFile, "name")
        XCTAssertEqual(rows[0].beforeCoverage, 0.23)
        XCTAssertEqual(rows[0].afterCoverage, 0.91)
        XCTAssertFalse(rows[0].test)

        XCTAssertEqual(rows[1].sourceFile, "testName")
        XCTAssertEqual(rows[1].beforeCoverage, 0.92)
        XCTAssertEqual(rows[1].afterCoverage, 0.22)
        XCTAssertFalse(rows[1].test)
    }

    func createProjectWithTargets(nameA: String, coverageA: Double, nameB: String, coverageB: Double) -> Project {
        let file = File(coveredLines: 0, lineCoverage: coverageA, path: "", functions: [Function](), name: nameA, executableLines: 0)
        var files = [File]()
        files.append(file)
        let target = Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: "")

        let testFile = File(coveredLines: 0, lineCoverage: coverageB, path: "", functions: [Function](), name: nameB, executableLines: 0)
        var testFiles = [File]()
        testFiles.append(testFile)
        let testTarget = Target(coveredLines: 0, lineCoverage: 0, files: testFiles, name: "", executableLines: 0, buildProductPath: "")

        var targets = [Target]()
        targets.append(target)
        targets.append(testTarget)
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }
}
