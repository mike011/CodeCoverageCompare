//
//  Parser.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class Parser: NSObject, XMLParserDelegate {

    var project = CoveredProject()

    //var lines = [String:[CoveredLine]]()

    // Create XMLParser instance:
    init(withFileName name: String) {
        super.init()
        let url = URL(fileURLWithPath: name)
        let xmlParser = XMLParser(contentsOf: url)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }

    // Implement didStartElement method and do the magic!

    var name = ""

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "class" {
            if let filename = attributeDict["filename"] {
                name = filename
                project.add(class: name)
            }
        } else if elementName == "line" {
            let lineNumber = Int(attributeDict["number"] ?? "0") ?? 0
            let hits = Int(attributeDict["hits"] ?? "0") ?? 0
            project.add(lineNumber: lineNumber, hits: hits, toClass: name)
        }
    }
}
