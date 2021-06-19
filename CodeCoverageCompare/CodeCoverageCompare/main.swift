//
//  main.swift
//  CodeCoverageCompare
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

func go(arguments: Arguments) {
    let beforeFileName = arguments.beforeCoverageJSON
    let afterFileName = arguments.afterCoverageJSON

    var before: Project?
    if let beforeFileName = beforeFileName {
        before = Utils.getCoverageFile(file: beforeFileName)
    }
    guard let after = Utils.getCoverageFile(file: afterFileName) else {
        return
    }
    let writeLocation = Utils.getParentURL(file: afterFileName)

    let fileList = arguments.includeFilesFileName ?? ""
    let listOfFiles = Utils.load(file: fileList)

    let ignoreList = arguments.ignoreFilesFileName ?? ""
    let listOfIgnores = Utils.convertToRegex(fromGlobLines: Utils.load(file: ignoreList))

    let cc = CoverageComparison(
        writeLocation: writeLocation,
        before: before,
        after: after,
        fileList: listOfFiles,
        ignoreList: listOfIgnores
    )

    let beforeURLBasePath = arguments.beforeURLPath
    let afterURLBasePath = arguments.afterURLPath
    cc.printTable(beforeLink: beforeURLBasePath, afterLink: afterURLBasePath)
}

if CommandLine.arguments.count != 2 {
    print("Missing argument, you need to specify the json file that matches the Arguments.swift file")
    fatalError()
}

let arguments = Utils.loadData(type: Arguments.self, file: CommandLine.arguments[1])!
go(arguments: arguments)
