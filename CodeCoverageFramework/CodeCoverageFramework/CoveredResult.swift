//
//  CoveredResult.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-27.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class CoveredResult {

    /// Indicates classes that are not in the base file.
    var addedClasses = [CoveredClass]()

    /// Indicates classes that are in the base, but not the comparison file.
    var removedClasses = [CoveredClass]()

    /// New Lines of code
    // These are not in the base, but in the comparsion file.
    var newLines = [CoveredClass]()

    /// Deleted lines of code
    /// These are in the base, but not in the comparsion file.
    var deletedLines = [CoveredClass]()

    /// The line existed before hand and is now covered.
    /// Lines of code that are in both files, but are now covered.
    var coveredLines = [CoveredClass]()

    /// The line existed before hand and is no longer covered.
    /// Lines of code that are in both files, but are now NOT covered.
    var notCoveredLines = [CoveredClass]()
}
