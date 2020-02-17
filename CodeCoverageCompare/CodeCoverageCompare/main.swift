//
//  main.swift
//  CodeCoverageCompare
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

func go(arguments: [String]) {
    if arguments.count != 5, arguments.count != 6, arguments.count != 7 {
        print("Missing arguments, expected the following: ")
        print("\t1 - develop json file")
        print("\t2 - pr json file")
        print("\t3 - develop base URL path")
        print("\t4 - pr base URL path")
        print("\t5 - file that lists files to show (optional)")
        print("\t6 - file that lists types of file to ignore")
        fatalError()
    }

    let beforeFileName = arguments[1]
    let afterFileName = arguments[2]
    let devURLBasePath = arguments[3]
    let prURLBasePath = arguments[4]
    let fileList = arguments.count >= 6 ? arguments[5] : ""
    let ignoreList = arguments.count == 7 ? arguments[6] : ""

    guard let before = Utils.getCoverageFile(file: beforeFileName),
        let after = Utils.getCoverageFile(file: afterFileName) else {
        return
    }
    let writeLocation = Utils.getParentURL(file: afterFileName)

    let listOfFiles = Utils.load(file: fileList)
    let listOfIgnores = Utils.convertToRegex(fromGlobLines: Utils.load(file: ignoreList))

    let cc = CoverageComparison(
        writeLocation: writeLocation,
        before: before,
        after: after,
        fileList: listOfFiles,
        ignoreList: listOfIgnores
    )
    cc.printTable(devLink: devURLBasePath, prLink: prURLBasePath)
}

go(arguments: CommandLine.arguments)
