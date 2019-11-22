//
//  Utils.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

public class Utils {
    public static func getCoverageFile(file: String) -> Project? {

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: file) {
            print("File not found: \(file)")
            return nil
        }

        let url = URL(fileURLWithPath: file)

        let json = try! Data(contentsOf: url)

        let decoder = JSONDecoder()
        return try! decoder.decode(Project.self, from: json)
    }

    public static func getParentFileName(from file: String) -> URL {
        let url = URL(fileURLWithPath: file)
        return url.deletingLastPathComponent()
    }
}
