//
//  CoveredClass.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class CoveredClass {
    var name: String
    var lines = [CoveredLine]()

    init(name: String) {
        self.name = name
    }

    func getLinesCovered() -> Int {
        return lines.count
    }
}
