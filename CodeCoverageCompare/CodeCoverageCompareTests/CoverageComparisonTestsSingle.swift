//
//  CoverageComparisonTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import Testing

/// Makes sure reading the coverage for the before and after arguments works expected
@Suite struct CoverageComparisonSingleTests {
    // MARK: - No Coverage

    @Test func noCoverage() {
        let before = Project(coveredLines: 0, lineCoverage: 0, targets: [Target](), executableLines: 0)
        let after = Project(coveredLines: 0, lineCoverage: 0, targets: [Target](), executableLines: 0)
        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        let rows = cc.getFilesChanged()
        #expect(rows.isEmpty)
    }

    // MARK: - Single File Covered

    @Test func coverageAdded() {
        let before = Project(coveredLines: 0, lineCoverage: 0, targets: [Target](), executableLines: 0)
        let after = createProject()

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()
        #expect(!rows.isEmpty)
        #expect(rows.count == 2)
        #expect(rows.first!.sourceFile == "name")
        #expect(rows.first!.beforeCoverage == nil)
        #expect(rows.first!.afterCoverage == 1.0)
        #expect(!rows.first!.test)
    }

    @Test func getFileChangedOverallCoverage() {
        let before = createProject()
        let after = createProject()

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()
        #expect(!rows.isEmpty)
        #expect(rows.count == 2)

        #expect(rows[1].sourceFile == "index")
        #expect(rows[1].beforeCoverage == 0.1)
        #expect(rows[1].afterCoverage == 0.1)
        #expect(!rows[1].test)
    }

    @Test func coverageRemoved() {
        let before = createProject()
        let after = Project(coveredLines: 0, lineCoverage: 0, targets: [Target](), executableLines: 0)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()
        #expect(!rows.isEmpty)
        #expect(rows.count == 1)
        #expect(rows.first!.sourceFile == "name")
        #expect(rows.first!.beforeCoverage == 1.0)
        #expect(rows.first!.afterCoverage == nil)
        #expect(!rows.first!.test)
    }

    func createProject() -> Project {
        var files = [File]()
        files.append(File(coveredLines: 1, lineCoverage: 1.0, path: "path", functions: [Function](), name: "name", executableLines: 10))
        var targets = [Target]()
        targets.append(Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: ""))
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // MARK: - Multiple files

    @Test func coverageAddedForMultipleFiles() {
        let before = Project(coveredLines: 0, lineCoverage: 0, targets: [Target](), executableLines: 0)
        let after = createProjectWithMultipleFiles()

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()

        #expect(!rows.isEmpty)
        #expect(rows.count == 2)

        #expect(rows[0].sourceFile == "name")
        #expect(rows[0].beforeCoverage == nil)
        #expect(rows[0].afterCoverage == 1.0)
        #expect(!rows[0].test)

        #expect(rows[1].sourceFile == "name2")
        #expect(rows[1].beforeCoverage == nil)
        #expect(rows[1].afterCoverage == 0.5)
        #expect(!rows[1].test)
    }

    @Test func coverageRemovedForMultipleFiles() {
        let before = createProjectWithMultipleFiles()
        let after = Project(coveredLines: 0, lineCoverage: 0, targets: [Target](), executableLines: 0)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = Array(cc.getFilesChanged())

        #expect(!rows.isEmpty)
        #expect(rows.count == 2)

        #expect(rows[0].sourceFile == "name")
        #expect(rows[0].beforeCoverage == 1.0)
        #expect(rows[0].afterCoverage == nil)
        #expect(!rows[0].test)

        #expect(rows[1].sourceFile == "name2")
        #expect(rows[1].beforeCoverage == 0.5)
        #expect(rows[1].afterCoverage == nil)
        #expect(!rows[1].test)
    }

    func createProjectWithMultipleFiles() -> Project {
        var files = [File]()
        files.append(File(coveredLines: 0, lineCoverage: 1.0, path: "", functions: [Function](), name: "name", executableLines: 0))
        files.append(File(coveredLines: 0, lineCoverage: 0.5, path: "", functions: [Function](), name: "name2", executableLines: 0))
        var targets = [Target]()
        targets.append(Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: ""))
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // MARK: - Different Targets with Coverage

    @Test func coverageAddedToSeperateTarget() {
        let before = Project(coveredLines: 0, lineCoverage: 0, targets: [Target](), executableLines: 0)
        let after = createProjectWithTargets()

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()

        #expect(!rows.isEmpty)
        #expect(rows.count == 2)

        #expect(rows[0].sourceFile == "name")
        #expect(rows[0].beforeCoverage == nil)
        #expect(rows[0].afterCoverage == 0.6)
        #expect(!rows[0].test)

        #expect(rows[1].sourceFile == "testName")
        #expect(rows[1].beforeCoverage == nil)
        #expect(rows[1].afterCoverage == 0.8)
        #expect(!rows[1].test)
    }

    func createProjectWithTargets() -> Project {
        let file = File(coveredLines: 0, lineCoverage: 0.6, path: "", functions: [Function](), name: "name", executableLines: 0)
        var files = [File]()
        files.append(file)
        let target = Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: "")

        let testFile = File(coveredLines: 0, lineCoverage: 0.8, path: "", functions: [Function](), name: "testName", executableLines: 0)
        var testFiles = [File]()
        testFiles.append(testFile)
        let testTarget = Target(coveredLines: 0, lineCoverage: 0, files: testFiles, name: "", executableLines: 0, buildProductPath: "")

        var targets = [Target]()
        targets.append(target)
        targets.append(testTarget)
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }
}
