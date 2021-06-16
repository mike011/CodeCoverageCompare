//
//  Arguments.swift
//  CodeCoverageCompare
//
//  Created by Michael Charland on 2021-06-15.
//  Copyright © 2021 Michael Charland. All rights reserved.
//

import Foundation

// MARK: - Arguments

struct Arguments: Decodable {
    let afterCoverageJSON: String
    let afterURLPath: String

    let beforeCoverageJSON: String
    let beforeURLPath: String

    let includeFilesFileName: String?
    let ignoreFilesFileName: String?
}
