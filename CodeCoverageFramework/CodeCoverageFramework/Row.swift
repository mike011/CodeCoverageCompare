//
//  Row.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-12.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

struct Row {
    var change: String {
        var change = ""
        if pr == 1 {
            change = "💯"
        } else if pr == 0 {
            change = "🚫"
        } else if(develop > pr) {
           change = "👎"
        } else if(pr > develop) {
           change = "👍"
        }
        return change
    }
    let file: String
    let develop: Double
    let pr: Double
    var test: Bool {
        return file.contains("Test")
    }

    func toString(devLink: String, prLink: String) -> String {
        var name = file
        if let period = file.firstIndex(of: ".") {
            name = file.substring(to: period)
        }
        let developPercentage = getLink(baseURL: devLink, value: develop)
        let prPercentage = getLink(baseURL: prLink, value: pr)
        return "|\(change)|\(name)|\(developPercentage)|\(prPercentage)|"
    }

    func getLink(baseURL: String, value: Double) -> String {
        let url = "\(baseURL)/\(file).html"
        let title = String(format: "%.0f", value * 100)
        return "<a href=\(url)>\(title)%</a>"
    }
}

extension Row: Hashable {
    static func == (lhs: Row, rhs: Row) -> Bool {
        return lhs.file == rhs.file
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(file)
    }
}
