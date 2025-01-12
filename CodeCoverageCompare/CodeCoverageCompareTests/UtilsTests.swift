//
//  UtilsTests.swift
//  CodeCoverageCompareTests
//
//  Created by Michael Charland on 2019-12-01.
//  Copyright © 2019 Michael Charland. All rights reserved.
//

import Foundation
import Testing

@Suite struct UtilsTests {
    @Test func getParentFileNameWithSlashReturnsFolder() {
        #expect(Utils.getParentURL(file: "a/b.json").absoluteString == URL(fileURLWithPath: "a").absoluteString + "/")
    }

    @Test func getParentFileForURL() {
        #expect(Utils.getParentURL(web: "http://www.nba.com/b.json").absoluteString == URL(string: "http://www.nba.com/")?.absoluteURL.absoluteString)
    }

    @Test func fromGlobLines() {
        var globLines = [String]()
        globLines.append("a")
        globLines.append("*Pod*")
        globLines.append("UI*")
        globLines.append("a.swift")

        let result = Utils.convertToRegex(fromGlobLines: globLines)
        #expect(result[0] == "a")
        #expect(result[1] == ".*Pod.*")
        #expect(result[2] == "UI.*")
        #expect(result[3] == "a\\.swift")
    }

    @Test func loadData() {
        #expect(Utils.loadData(type: Arguments.self, file: nil) == nil)
        #expect(Utils.loadData(type: Arguments.self, file: "File does not exist") == nil)
        #expect(Utils.loadData(type: Arguments.self, file: EXAMPLE_JSON) != nil)
    }
}
