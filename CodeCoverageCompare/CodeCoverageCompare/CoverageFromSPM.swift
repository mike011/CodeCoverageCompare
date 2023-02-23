// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(CoverageFromSPM.self, from: jsonData)

import Foundation

// MARK: - CoverageFromSPM
struct CoverageFromSPM: Decodable {
     let data: [Datum]
     let type, version: String
}

// MARK: - Datum
struct Datum: Decodable {
    let files: [SPMFile]
    let functions: [SPMFunction]
    let totals: Totals
}

// MARK: - File
struct SPMFile: Decodable {
    // let branches, expansions: [JSONAny]
    let filename: String
    let segments: [[Segment]]
    let summary: Totals
}

enum Segment: Decodable {
    case bool(Bool)
    case integer(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        throw DecodingError.typeMismatch(Segment.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Segment"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Totals
struct Totals: Decodable {
    let branches, functions, instantiations, lines: Branches
    let regions: Branches
}

// MARK: - Branches
struct Branches: Decodable {
    let count, covered: Int
    let notcovered: Int?
    let percent: Double
}

// MARK: - Function
struct SPMFunction: Decodable {
    // let branches: [JSONAny]
    let count: Int
    let filenames: [String]
    let name: String
    let regions: [[Int]]
}
