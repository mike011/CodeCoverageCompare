//
//  CoverageCompareTests.swift
//  CodeCoverageFrameworkTests
//
//  Created by Michael Charland on 2019-11-15.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest

class CoverageCompareTests: XCTestCase {

    // MARK: - Single File Covered

    func testCoverageAdded() {
        let before = createProject(coverage: 0.3)
        let after = createProject(coverage: 0.5)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

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
        let before = createProjectWithMultipleFiles(sourceCoverage: 0.2, testCoverage: 0.9)
        let after = createProjectWithMultipleFiles(sourceCoverage: 0.1, testCoverage: 0.92)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

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

    func createProjectWithMultipleFiles(sourceCoverage: Double, testCoverage: Double) -> Project {
        var files = [File]()
        files.append(File(coveredLines: 0, lineCoverage: sourceCoverage, path: "", functions: [Function](), name: "name", executableLines: 0))
        files.append(File(coveredLines: 0, lineCoverage: testCoverage, path: "", functions: [Function](), name: "name2", executableLines: 0))
        var targets = [Target]()
        targets.append(Target(coveredLines: 0, lineCoverage: 0, files: files, name: "", executableLines: 0, buildProductPath: ""))
        return Project(coveredLines: 0, lineCoverage: 0, targets: targets, executableLines: 0)
    }

    // MARK: - Different Targets with Coverage

    func testCoverageAddedToSeperateTarget() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.22, testName: "testName", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

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
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())

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

    func testGetCoverageFileNotCovered() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, sourcePath: "folder/name", testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        var files = [String]()
        files.append("folder/name")
        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: files, ignoreList: [String]())

        let rows = cc.getFilesChanged()

        XCTAssertFalse(rows.isEmpty)
        XCTAssertEqual(rows.count, 1)

        XCTAssertEqual(rows[0].sourceFile, "name")
        XCTAssertEqual(rows[0].beforeCoverage, 0.23)
        XCTAssertEqual(rows[0].afterCoverage, 0.91)
        XCTAssertFalse(rows[0].test)
    }

    func testCreateTableNoRow() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, sourcePath: "folder/name", testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        let result = cc.createTable(rows: [Row](), devLink: "", prLink: "")
        XCTAssertTrue(result.isEmpty)
    }

    func testCreateTableRows() {
        let before = createProjectWithTargets(sourceName: "name", sourceCoverage: 0.23, sourcePath: "folder/name", testName: "testName", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "testName", sourceCoverage: 0.22, testName: "name", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "source", beforeCoverage: 0.1, afterCoverage: 0.2))

        // When
        let result = cc.createTable(rows: rows, devLink: "", prLink: "a.b/s")

        // Then
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0],  "|Change|File|Develop|PR|")
        XCTAssertEqual(result[1],  "|:----:|----|:-----:|:--:|")
        XCTAssertEqual(result[2],  "|👍|<a href=a.b/source_comparison.html>source</a>|10%|20%|")
    }

    func testCreateTableRowsForTests() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceTest", beforeCoverage: 0.1, afterCoverage: 0.2))

        // When
        let result = cc.createTable(rows: rows, devLink: "", prLink: "http://a.b/s/")

        // THen
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0],  "|Change|File|Develop|PR|")
        XCTAssertEqual(result[1],  "|:----:|----|:-----:|:--:|")
        XCTAssertEqual(result[2],  "|👍|<a href=http://a.b/sourceTest_comparison.html>sourceTest</a>|10%|20%|")
    }

    func testCreateTableRowsForTests100Percent() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceTest", beforeCoverage: 23/23, afterCoverage: 51/51))

        // When
        let result = cc.createTable(rows: rows, devLink: "", prLink: "http://a.b/s/")

        // THen
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0],  "|Change|File|Develop|PR|")
        XCTAssertEqual(result[1],  "|:----:|----|:-----:|:--:|")
        XCTAssertEqual(result[2],  "|💯|<a href=http://a.b/sourceTest_comparison.html>sourceTest</a>|100%|100%|")
    }

    func testCreateTableRowsForMultipleFiles() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceB", beforeCoverage: 0.1, afterCoverage: 0.2))
        rows.append(Row(sourceFile: "sourceA", beforeCoverage: 0.3, afterCoverage: 0.25))

        // When
        let result = cc.createTable(rows: rows, devLink: "", prLink: "http://www.github.com/mike011/ccc/slather")

        // Then
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0],  "|Change|File|Develop|PR|")
        XCTAssertEqual(result[1],  "|:----:|----|:-----:|:--:|")
        XCTAssertEqual(result[2],  "|👎|<a href=http://www.github.com/mike011/ccc/sourceA_comparison.html>sourceA</a>|30%|25%|")
        XCTAssertEqual(result[3],  "|👍|<a href=http://www.github.com/mike011/ccc/sourceB_comparison.html>sourceB</a>|10%|20%|")
    }

    func testCreateTableRowsForMultipleTestFiles() {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0.92)
        let after = createProjectWithTargets(sourceName: "", sourceCoverage: 0, testName: "", testCoverage: 0.91)

        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: [String](), ignoreList: [String]())
        var rows = [Row]()
        rows.append(Row(sourceFile: "sourceTestB", beforeCoverage: 0.1, afterCoverage: 0.2))
        rows.append(Row(sourceFile: "sourceTestA", beforeCoverage: 0.3, afterCoverage: 0.25))

        // When
        let result = cc.createTable(rows: rows, devLink: "", prLink: "a.b/s")

        // Then
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0],  "|Change|File|Develop|PR|")
        XCTAssertEqual(result[1],  "|:----:|----|:-----:|:--:|")
        XCTAssertEqual(result[2],  "|👎|<a href=a.b/sourceTestA_comparison.html>sourceTestA</a>|30%|25%|")
        XCTAssertEqual(result[3],  "|👍|<a href=a.b/sourceTestB_comparison.html>sourceTestB</a>|10%|20%|")
    }

    // MARK - isValid

    func testIsValidNoFiltering() {
        let cc = createCoverageComparison()
        let file = File(path: "path/File", name: "File")
        XCTAssertTrue(cc.isValid(file: file))
    }

    func testIsValidFileIncludedOnList() {
        var filesList = [String]()
        filesList.append("File")
        let cc = createCoverageComparison(fileList: filesList)
        let file = File(path: "path/File", name: "File")
        XCTAssertTrue(cc.isValid(file: file))
    }

    func testIsValidFileNotIncludedOnList() {
        var filesList = [String]()
        filesList.append("File2")
        let cc = createCoverageComparison(fileList: filesList)
        let file = File(path: "path/File", name: "File")
        XCTAssertFalse(cc.isValid(file: file))
    }

    func testIsValidFileIgnored() {
        var ignoresList = [String]()
        ignoresList.append(".*File")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "path/File", name: "File")
        XCTAssertFalse(cc.isValid(file: file))
    }

    func testIsValidFileNotIgnored() {
        var ignoresList = [String]()
        ignoresList.append("*File")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "path/Mars", name: "Mars")
        XCTAssertTrue(cc.isValid(file: file))
    }

    func testGetCoverageFilesAreIgnoredPodFileExactMatch() {
        var ignoresList = [String]()
        ignoresList.append("Pod/name")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "Pod/name", name: "Mars")
        XCTAssertFalse(cc.isValid(file: file))
    }

    func testGetCoverageFilesAreIgnoredPodFileRegex() {
        var ignoresList = [String]()
        ignoresList.append(".*Pod.*")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "Pod/name", name: "Mars")
        XCTAssertFalse(cc.isValid(file: file))
    }

    func testGetCoverageFilesAreIgnoredUIFile() {
        var ignoresList = [String]()
        ignoresList.append("UI.*.swift")
        let cc = createCoverageComparison(ignoreList: ignoresList)
        let file = File(path: "Pod/UIname.swift", name: "")
        XCTAssertFalse(cc.isValid(file: file))
    }

    func testGetCoverageFilesAreIgnored() {
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
        XCTAssertFalse(cc.isValid(file: File(path: "Pod/UIname.swift", name: "")))
        XCTAssertFalse(cc.isValid(file: File(path: "UIname.swift", name: "")))
        XCTAssertFalse(cc.isValid(file: File(path: "objc.c", name: "")))
        XCTAssertFalse(cc.isValid(file: File(path: "objc.m", name: "")))
        XCTAssertFalse(cc.isValid(file: File(path: "MainNavigationController.swift", name: "")))
        XCTAssertFalse(cc.isValid(file: File(path: "MainView.swift", name: "")))

        XCTAssertTrue(cc.isValid(file: File(path: "ViewModel.swift", name: "")))
        XCTAssertTrue(cc.isValid(file: File(path: "Factiliator.swift", name: "")))
        XCTAssertTrue(cc.isValid(file: File(path: "Provider.swift", name: "")))
    }

    func createCoverageComparison(fileList: [String] = [String](), ignoreList: [String] = [String]()) -> CoverageComparison {
        let before = createProjectWithTargets(sourceName: "", sourceCoverage: 0, sourcePath: "", testName: "", testCoverage: 0)
        let after = before
        let cc = CoverageComparison(writeLocation: URL(fileURLWithPath: ""), before: before, after: after, fileList: fileList, ignoreList: ignoreList)
        return cc
    }
}

private extension File {
    init(path: String, name: String) {
        self.init(coveredLines: 0, lineCoverage: 0, path: path, functions: [Function](), name: name, executableLines: 0)
    }
}
