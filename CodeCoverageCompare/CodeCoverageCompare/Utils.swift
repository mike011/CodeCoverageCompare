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
            print("Coverage file not found: \(file)")
            return nil
        }

        let url = URL(fileURLWithPath: file)

        let json = try! Data(contentsOf: url)

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Project.self, from: json)
        } catch {
            let elements: [Element] = try!
                decoder.decode([Element].self, from: json)
            let target = Target(coveredLines: 0, lineCoverage: 0, files: elements[0].files, name: "", executableLines: 0, buildProductPath: "")
            return Project(coveredLines: 0, lineCoverage: 0, targets: [target], executableLines: 0)
        }
    }

    public static func getParentURL(file: String) -> URL {
        let url = URL(fileURLWithPath: file)
        return url.deletingLastPathComponent()
    }

    public static func getParentURL(web: String) -> URL {
        guard let url = URL(string: web) else {
            return URL(fileURLWithPath: web)
        }
        return url.deletingLastPathComponent()
    }

    public static func load(file: String) -> [String] {

        guard !file.isEmpty else {
            return [String]()
        }

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: file) {
            print("File not found: \(file)")
            return [String]()
        }

        let data = fileManager.contents(atPath: file)
        let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let string = datastring! as String
        return string.components(separatedBy: "\n")
    }

    public static func convertToRegex(fromGlobLines lines: [String]) -> [String] {
        var result = [String]()
        for var line in lines {

            // from: https://en.wikipedia.org/wiki/Glob_%28programming%29
            line = line.replacingOccurrences(of: ".", with: "\\.")
            line = line.replacingOccurrences(of: "?", with: ".")
            line = line.replacingOccurrences(of: "*", with: ".*")
            result.append(line)
        }
        return result;
    }
}
