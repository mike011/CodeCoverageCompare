//
//  ArgumentsTests.swift
//  CodeCoverageCompareTests
//
//  Created by Michael Charland on 2021-06-15.
//  Copyright © 2021 Michael Charland. All rights reserved.
//

import XCTest

private let MOCK_ARGUMENTS = Arguments(
    afterCoverageJSON: "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json",
    afterURLPath: "https://mike011.github.io/after",
    beforeCoverageJSON: "EXAMPLE_LOG_FOLDER",
    beforeURLPath: "beforeURLPath",
    includeFilesFileName: "includes.txt",
    ignoreFilesFileName: "ignores.txt"
)

class ArgumentsTests: XCTestCase {
    func testAllArguments() throws {
        let jsonString = """
        {
        "afterCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json",
        "afterURLPath": "https://mike011.github.io/after",
        "beforeCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/before/coverage.json",
        "beforeURLPath": "https://mike011.github.io/before",
        "includeFilesFileName": "/User/vagrant/fastlane/include.txt",
        "ignoreFilesFileName": "/User/vagrant/fastlane/exclude.txt",
        }
        """

        let data = jsonString.data(using: .utf8)!
        let args = try XCTUnwrap(JSONDecoder().decode(Arguments.self, from: data))
        XCTAssertEqual(args.afterCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json")
        XCTAssertEqual(args.afterURLPath, "https://mike011.github.io/after")
        XCTAssertEqual(args.beforeCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/before/coverage.json")
        XCTAssertEqual(args.beforeURLPath, "https://mike011.github.io/before")
        XCTAssertEqual(args.includeFilesFileName, "/User/vagrant/fastlane/include.txt")
        XCTAssertEqual(args.ignoreFilesFileName, "/User/vagrant/fastlane/exclude.txt")
    }

    func testNoIncludeOrIgnore() throws {
        let jsonString = """
        {
        "afterCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json",
        "afterURLPath": "https://mike011.github.io/after",
        "beforeCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/before/coverage.json",
        "beforeURLPath": "https://mike011.github.io/before",
        }
        """

        let data = jsonString.data(using: .utf8)!
        let args = try XCTUnwrap(JSONDecoder().decode(Arguments.self, from: data))
        XCTAssertEqual(args.afterCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json")
        XCTAssertEqual(args.afterURLPath, "https://mike011.github.io/after")
        XCTAssertEqual(args.beforeCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/before/coverage.json")
        XCTAssertEqual(args.beforeURLPath, "https://mike011.github.io/before")
        XCTAssertNil(args.includeFilesFileName)
        XCTAssertNil(args.ignoreFilesFileName)
    }
}
