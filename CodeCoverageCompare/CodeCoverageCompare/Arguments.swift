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
    let childCoverageJSON: String
    let childURLPath: String

    let parentCoverageJSON: String
    let parentURLPath: String

    let includeFilesFileName: String?
    let ignoreFilesFileName: String?
}
