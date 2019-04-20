import Foundation

struct CoveredLine {
    var line: Int
    var hits: Int
}

class CoveredClass {
    var name: String
    var lines = [CoveredLine]()

    init(name: String) {
        self.name = name
    }
}

class CoveredProject {
    var coverdClasses = [String:CoveredClass]()
}

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
                project.coverdClasses[name] = CoveredClass(name: name)
            }
        } else if elementName == "line" {
            let lineNumber = Int(attributeDict["number"] ?? "0") ?? 0
            let hits = Int(attributeDict["hits"] ?? "0") ?? 0
            let cc = project.coverdClasses[name]
            cc?.lines.append(CoveredLine(line: lineNumber, hits: hits))
        }
    }
}

let parser = Parser(withFileName: "//Users/michael/Documents/git/CodeCoverageCompare/example/coverageA.xml")

let parser2 = Parser(withFileName: "//Users/michael/Documents/git/CodeCoverageCompare/example/coverageB.xml")

func compare(a: CoveredProject, b: CoveredProject) {

}

compare(a: parser.project, b: parser2.project)
