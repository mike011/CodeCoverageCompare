//
//  CoverageCompareTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import Testing

@Suite class CoverageCompareTests {
    // MARK: - Single File Covered
    
    @Test func coverageAdded() {
        let before = createProject(coverage: 0.3)
        let after = createProject(coverage: 0.5)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()
        #expect(!rows.isEmpty)
        #expect(rows.count == 1)
        #expect(rows.first!.sourceFile == "name")
        #expect(rows.first!.beforeCoverage == 0.3)
        #expect(rows.first!.afterCoverage == 0.5)
        #expect(!rows.first!.test)
    }

    func createProject(coverage: Double) -> Project {
        var files = [File]()
        files.append(File(coveredLines: 0, lineCoverage: coverage, path: "", functions: [Function](), name: "name", executableLines: 0))
        var targets = [Target]()
        targets.append(Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: ""))
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // MARK: - Multiple files

    @Test func coverageAddedForMultipleFiles() {
        let before = createProjectWithMultipleFiles(sourceCoverage: 0.2, testCoverage: 0.9)
        let after = createProjectWithMultipleFiles(sourceCoverage: 0.1, testCoverage: 0.92)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()

        #expect(!rows.isEmpty)
        #expect(rows.count == 2)

        #expect(rows[0].sourceFile == "name")
        #expect(rows[0].beforeCoverage == 0.2)
        #expect(rows[0].afterCoverage == 0.1)
        #expect(!rows[0].test)

        #expect(rows[1].sourceFile == "name2")
        #expect(rows[1].beforeCoverage == 0.9)
        #expect(rows[1].afterCoverage == 0.92)
        #expect(!rows[1].test)
    }

    func createProjectWithMultipleFiles(sourceCoverage: Double, testCoverage: Double) -> Project {
        var files = [File]()
        files.append(File(coveredLines: 0, lineCoverage: sourceCoverage, path: "", functions: [Function](), name: "name", executableLines: 0))
        files.append(File(coveredLines: 0, lineCoverage: testCoverage, path: "", functions: [Function](), name: "name2", executableLines: 0))
        var targets = [Target]()
        targets.append(Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: ""))
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // MARK: - Different Targets with Coverage

    @Test func coverageAddedToSeperateTarget() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.22, testName: "testName", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()

        #expect(!rows.isEmpty)
        #expect(rows.count == 2)

        #expect(rows[0].sourceFile == "name")
        #expect(rows[0].beforeCoverage == 0.23)
        #expect(rows[0].afterCoverage == 0.22)
        #expect(!rows[0].test)

        #expect(rows[1].sourceFile == "testName")
        #expect(rows[1].beforeCoverage == 0.92)
        #expect(rows[1].afterCoverage == 0.91)
        #expect(!rows[1].test)
    }

    @Test func coverageAddedToSeperateTargetFlip() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

        let rows = cc.getFilesChanged()

        #expect(!rows.isEmpty)
        #expect(rows.count == 2)

        #expect(rows[0].sourceFile == "name")
        #expect(rows[0].beforeCoverage == 0.23)
        #expect(rows[0].afterCoverage == 0.91)
        #expect(!rows[0].test)

        #expect(rows[1].sourceFile == "testName")
        #expect(rows[1].beforeCoverage == 0.92)
        #expect(rows[1].afterCoverage == 0.22)
        #expect(!rows[1].test)
    }

    func createProjectWithTargets(sourceName: String, sourceCoverage: Double, sourcePath: String = "", testName: String, testCoverage: Double) -> Project {
        let file = File(coveredLines: 0, lineCoverage: sourceCoverage, path: sourcePath, functions: [Function](), name: sourceName, executableLines: 0)
        var files = [File]()
        files.append(file)
        let target = Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: "")

        let testFile = File(coveredLines: 0, lineCoverage: testCoverage, path: "", functions: [Function](), name: testName, executableLines: 0)
        var testFiles = [File]()
        testFiles.append(testFile)
        let testTarget = Target(coveredLines: 0, lineCoverage: 0, files: testFiles, name: "", executableLines: 0, buildProductPath: "")

        var targets = [Target]()
        targets.append(target)
        targets.append(testTarget)
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // Mark: - File list not covered

    @Test func getCoverageFileNotCovered() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, sourcePath: "folder/name", testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        var files = [String]()
        files.append("folder/name")
        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: files, ignoreList: [String]())

        let rows = cc.getFilesChanged()

        #expect(!rows.isEmpty)
        #expect(rows.count == 1)

        #expect(rows[0].sourceFile == "name")
        #expect(rows[0].beforeCoverage == 0.23)
        #expect(rows[0].afterCoverage == 0.91)
        #expect(!rows[0].test)
    }

    @Test func createTableNoRow() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, sourcePath: "folder/name", testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        let result = cc.createTable(rows: [Row](), beforeLink: "", afterLink: "")
        #expect(result.isEmpty)
    }

    @Test func createTableRows() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, sourcePath: "folder/name", testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "source", beforeCoverage: 0.1, afterCoverage: 0.2))

        // When
        let result = cc.createTable(rows: rows, beforeLink: "", afterLink: "a.b/s")

        // Then
        #expect(result.isEmpty)
    }

    @Test func createTableRowsNoURL() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, sourcePath: "folder/name", testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "source", beforeCoverage: 0.1, afterCoverage: 0.2))

        // When
        let result = cc.createTable(rows: rows, beforeLink: nil, afterLink: nil)

        // Then
        #expect(result.isEmpty)
    }

    @Test func createTableRowsForTests() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceTest", beforeCoverage: 0.1, afterCoverage: 0.2))

        // When
        let result = cc.createTable(rows: rows, beforeLink: "", afterLink: "http://a.b/s/")

        // THen
        #expect(result.isEmpty)
    }

    @Test func createTableRowsForTests100Percent() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceTest", beforeCoverage: 23 / 23, afterCoverage: 51 / 51))

        // When
        let result = cc.createTable(rows: rows, beforeLink: "", afterLink: "http://a.b/s/")

        // THen
        #expect(result.isEmpty)
    }

    @Test func createTableRowsForMultipleFiles() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceB", beforeCoverage: 0.1, afterCoverage: 0.2))
        rows.append(Row(sourceFile: "sourceA", beforeCoverage: 0.3, afterCoverage: 0.25))

        // When
        let result = cc.createTable(rows: rows, beforeLink: "", afterLink: "http://www.github.com/mike011/ccc/slather")

        // Then
        #expect(!result.isEmpty)
        #expect(result.count == 4)
        #expect(result[0] == "|Change|File|Before|After|")
        #expect(result[1] == "|:----:|----|:-----:|:--:|")
        #expect(result[2] == "|👎|<a href=http://www.github.com/mike011/ccc/sourceA_comparison.html>sourceA</a>|30%|25%|")
        #expect(result[3] == "|👍|<a href=http://www.github.com/mike011/ccc/sourceB_comparison.html>sourceB</a>|10%|20%|")
    }

    @Test func createTableRowsForMultipleTestFiles() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceTestB", beforeCoverage: 0.1, afterCoverage: 0.2))
        rows.append(Row(sourceFile: "sourceTestA", beforeCoverage: 0.3, afterCoverage: 0.25))

        // When
        let result = cc.createTable(rows: rows, beforeLink: "", afterLink: "a.b/s")

        // Then
        #expect(!result.isEmpty)
        #expect(result.count == 4)
        #expect(result[0] == "|Change|File|Before|After|")
        #expect(result[1] == "|:----:|----|:-----:|:--:|")
        #expect(result[2] == "|👎|<a href=a.b/sourceTestA_comparison.html>sourceTestA</a>|30%|25%|")
        #expect(result[3] == "|👍|<a href=a.b/sourceTestB_comparison.html>sourceTestB</a>|10%|20%|")
    }

    // MARK: - isValid

    @Test func isValidNoFiltering() {
        let cc = createCoverageComparison()
        let file = File(path: "path/File", name: "File")
        #expect(cc.isValid(file: file))
    }

    @Test func isValidFileIncludedOnList() {
        var filesList = [String]()
        filesList.append("File")
        let cc = createCoverageComparison(fileList: filesList)
        let file = File(path: "path/File", name: "File")
        #expect(cc.isValid(file: file))
    }

    @Test func isValidFileNotIncludedOnList() {
        var filesList = [String]()
        filesList.append("File2")
        let cc = createCoverageComparison(fileList: filesList)
        let file = File(path: "path/File", name: "File")
        #expect(!cc.isValid(file: file))
    }

    @Test func isValidFileIgnored() {
        var ignoresList = [String]()
        ignoresList.append(".*File")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "path/File", name: "File")
        #expect(!cc.isValid(file: file))
    }

    @Test func isValidFileNotIgnored() {
        var ignoresList = [String]()
        ignoresList.append("*File")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "path/Mars", name: "Mars")
        #expect(cc.isValid(file: file))
    }

    @Test func getCoverageFilesAreIgnoredPodFileExactMatch() {
        var ignoresList = [String]()
        ignoresList.append("Pod/name")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "Pod/name", name: "Mars")
        #expect(!cc.isValid(file: file))
    }

    @Test func getCoverageFilesAreIgnoredPodFileRegex() {
        var ignoresList = [String]()
        ignoresList.append(".*Pod.*")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "Pod/name", name: "Mars")
        #expect(!cc.isValid(file: file))
    }

    @Test func getCoverageFilesAreIgnoredUIFile() {
        var ignoresList = [String]()
        ignoresList.append("UI.*.swift")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "Pod/UIname.swift", name: "")
        #expect(!cc.isValid(file: file))
    }

    @Test func getCoverageFilesAreIgnored() {
        var globList = [String]()
        globList.append("*Pods*")
        globList.append("*Mock*")
        globList.append("*Tests*")
        globList.append("*.h")
        globList.append("*View.swift")
        globList.append("*ViewController*.swift")
        globList.append("*NavigationController.swift")
        globList.append("UI*.swift")
        globList.append("UI*Extensions.swift")
        globList.append("CA*.swift")
        globList.append("CA*Extensions.swift")
        globList.append("*External*")
        globList.append("*.m")
        globList.append("*.mm")
        globList.append("*.pch")
        globList.append("*.c")
        let ignoresList = Utils.convertToRegex(fromGlobLines: globList)
        let cc = createCoverageComparison(ignoreList: ignoresList)
        #expect(!cc.isValid(file: File(path: "Pod/UIname.swift", name: "")))
        #expect(!cc.isValid(file: File(path: "UIname.swift", name: "")))
        #expect(!cc.isValid(file: File(path: "objc.c", name: "")))
        #expect(!cc.isValid(file: File(path: "objc.m", name: "")))
        #expect(!cc.isValid(file: File(path: "MainNavigationController.swift", name: "")))
        #expect(!cc.isValid(file: File(path: "MainView.swift", name: "")))

        #expect(cc.isValid(file: File(path: "ViewModel.swift", name: "")))
        #expect(cc.isValid(file: File(path: "Factiliator.swift", name: "")))
        #expect(cc.isValid(file: File(path: "Provider.swift", name: "")))
    }

    func createCoverageComparison(fileList: [String] = [String](), ignoreList: [String] = [String]()) -> CoverageComparison {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0)
        let after = before
        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: fileList, ignoreList: ignoreList)
        return cc
    }
    
    // MARK: - getCoverageFile
    @Test func getCoverageFile() throws {
        let bundle = Bundle(for: type(of: self))
        let path = try #require(bundle.path(forResource: "coverage", ofType: "json"))
        let project = try #require(Utils.getProject(file: path))

        #expect(project.executableLines == 23)
        #expect(project.coveredLines == 20)
        #expect(project.lineCoverage == 0.8695652173913043)
    }
    
    @Test func getCoverageFile_SPM() throws {
        let bundle = Bundle(for: type(of: self))
        let path = try #require(bundle.path(forResource: "spm_coverage", ofType: "json"))
        let project = try #require(Utils.getProject(file: path))

        #expect(project.targets.count == 1)
        #expect(project.targets[0].files.count == 9)
        #expect(project.targets[0].files[0].name == "ExistingClassCoverageDown.swift")
    }
}

private extension File {
    init(path: String, name: String) {
        self.init(coveredLines: 0, lineCoverage: 0, path: path, functions: [Function](), name: name, executableLines: 0)
    }
}
