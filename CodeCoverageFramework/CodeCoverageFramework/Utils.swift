//
//  Utils.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

public class Utils {
    public static func loadCoverageFile(file: String) -> Project {

        let url = URL(fileURLWithPath: file)
        let json = try! Data(contentsOf: url)

        let decoder = JSONDecoder()
        return try! decoder.decode(Project.self, from: json)
    }
}
