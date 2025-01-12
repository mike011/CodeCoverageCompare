//
//  ArgumentsTests.swift
//  CodeCoverageCompareTests
//
//  Created by Michael Charland on 2021-06-15.
//  Copyright © 2021 Michael Charland. All rights reserved.
//

import Foundation
import Testing

private let MOCK_ARGUMENTS = Arguments(
    afterCoverageJSON: "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json",
    afterURLPath: "https://mike011.github.io/after",
    beforeCoverageJSON: "EXAMPLE_LOG_FOLDER",
    beforeURLPath: "beforeURLPath",
    includeFilesFileName: "includes.txt",
    ignoreFilesFileName: "ignores.txt"
)

@Suite struct ArgumentsTests {
    @Test func allArguments() throws {
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
        let args = try JSONDecoder().decode(Arguments.self, from: data)
        #expect(args.afterCoverageJSON == "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json")
        #expect(args.afterURLPath == "https://mike011.github.io/after")
        #expect(args.beforeCoverageJSON == "/User/vagrant/fastlane/PostBuildAnalyzer/before/coverage.json")
        #expect(args.beforeURLPath == "https://mike011.github.io/before")
        #expect(args.includeFilesFileName == "/User/vagrant/fastlane/include.txt")
        #expect(args.ignoreFilesFileName == "/User/vagrant/fastlane/exclude.txt")
    }

    @Test func noIncludeOrIgnore() throws {
        let jsonString = """
        {
        "afterCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json",
        "afterURLPath": "https://mike011.github.io/after",
        "beforeCoverageJSON": "/User/vagrant/fastlane/PostBuildAnalyzer/before/coverage.json",
        "beforeURLPath": "https://mike011.github.io/before",
        }
        """

        let data = jsonString.data(using: .utf8)!
        let args = try JSONDecoder().decode(Arguments.self, from: data)
        #expect(args.afterCoverageJSON == "/User/vagrant/fastlane/PostBuildAnalyzer/after/coverage.json")
        #expect(args.afterURLPath == "https://mike011.github.io/after")
        #expect(args.beforeCoverageJSON == "/User/vagrant/fastlane/PostBuildAnalyzer/before/coverage.json")
        #expect(args.beforeURLPath == "https://mike011.github.io/before")
        #expect(args.includeFilesFileName == nil)
        #expect(args.ignoreFilesFileName == nil)
    }
}
