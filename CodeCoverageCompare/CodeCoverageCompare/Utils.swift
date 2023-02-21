//
//  Utils.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

public class Utils {
    public static func getProject(file: String) -> Project? {
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
            let elements: CoverageFromSPM = try!
                decoder.decode(CoverageFromSPM.self, from: json)
            let target = Target(coveredLines: 0,
                                lineCoverage: 0,
                                files: convert(elements.data[0].files),
                                name: "",
                                executableLines: 0,
                                buildProductPath: "")
            return Project(coveredLines: 0, lineCoverage: 0, targets: [target], executableLines: 0)
        }
    }
    
    private static func convert(_ spmFiles: [SPMFile]) -> [File] {
        var result = [File]()
        for spmFile in spmFiles {
            let file = File(coveredLines: spmFile.summary.lines.covered,
                            lineCoverage: spmFile.summary.lines.percent/100,
                            path: spmFile.filename,
                            functions: nil,
                            name: getFilename(spmFile.filename),
                            executableLines: spmFile.summary.lines.count)
            result.append(file)
        }
        
        return result
    }
    
    private static func getFilename(_ from: String) -> String {
        return String(from.split(separator: "/").last ?? "")
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

    public static func loadData<T: Decodable>(type: T.Type, file: String?) -> T? {
        guard let file = file else {
            return nil
        }

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: file) {
            print("File not found: \(file)")
            return nil
        }

        if let data = fileManager.contents(atPath: file) {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch let DecodingError.keyNotFound(key, context) {
                fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
            } catch let DecodingError.typeMismatch(_, context) {
                fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
            } catch let DecodingError.valueNotFound(type, context) {
                fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
            } catch DecodingError.dataCorrupted(_) {
                fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
            } catch {
                fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
            }
        }
        return nil
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
        return result
    }
}
