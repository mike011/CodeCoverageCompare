//
//  ArgumentsTests.swift
//  CodeCoverageCompareTests
//
//  Created by Michael Charland on 2021-06-15.
//  Copyright © 2021 Michael Charland. All rights reserved.
//

import XCTest

private let MOCK_ARGUMENTS = Arguments(
    childCoverageJSON: "/User/vagrant/fastlane/PostBuildAnalyzer/child/coverage.json",
    childURLPath: "https://mike011.github.io/child",
    parentCoverageJSON: "EXAMPLE_LOG_FOLDER",
    parentURLPath: "parentURLPath",
    includeFilesFileName: "includes.txt",
    ignoreFilesFileName: "ignores.txt"
)

class ArgumentsTests: XCTestCase {
    func testAllArguments() throws {
        let jsonString = """
        {
        "childCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/child/coverage.json",
        "childURLPath": "https://mike011.github.io/child",
        "parentCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/parent/coverage.json",
        "parentURLPath": "https://mike011.github.io/parent",
        "includeFilesFileName": "/User/vagrant/fastlane/include.txt",
        "ignoreFilesFileName": "/User/vagrant/fastlane/exclude.txt",
        }
        """

        let data = jsonString.data(using: .utf8)!
        let args = try XCTUnwrap(JSONDecoder().decode(Arguments.self, from: data))
        XCTAssertEqual(args.childCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/child/coverage.json")
        XCTAssertEqual(args.childURLPath, "https://mike011.github.io/child")
        XCTAssertEqual(args.parentCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/parent/coverage.json")
        XCTAssertEqual(args.parentURLPath, "https://mike011.github.io/parent")
        XCTAssertEqual(args.includeFilesFileName, "/User/vagrant/fastlane/include.txt")
        XCTAssertEqual(args.ignoreFilesFileName, "/User/vagrant/fastlane/exclude.txt")
    }

    func testNoIncludeOrIgnore() throws {
        let jsonString = """
        {
        "childCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/child/coverage.json",
        "childURLPath": "https://mike011.github.io/child",
        "parentCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/parent/coverage.json",
        "parentURLPath": "https://mike011.github.io/parent",
        }
        """

        let data = jsonString.data(using: .utf8)!
        let args = try XCTUnwrap(JSONDecoder().decode(Arguments.self, from: data))
        XCTAssertEqual(args.childCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/child/coverage.json")
        XCTAssertEqual(args.childURLPath, "https://mike011.github.io/child")
        XCTAssertEqual(args.parentCoverageJSON, "/User/vagrant/fastlane/PostBuildAnalyzer/parent/coverage.json")
        XCTAssertEqual(args.parentURLPath, "https://mike011.github.io/parent")
        XCTAssertNil(args.includeFilesFileName)
        XCTAssertNil(args.ignoreFilesFileName)
    }
}
