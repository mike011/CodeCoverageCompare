//
//  main.swift
//  CodeCoverageCompare
//
//  Created by Michael Charland on 2019-04-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

let arguments = CommandLine.arguments

if arguments.count != 5 && arguments.count != 6 {
    print("Missing arguments, expected the following: ")
    print("\t1 - develop json file")
    print("\t2 - pr json file")
    print("\t3 - develop base URL path")
    print("\t4 - pr base URL path")
    print("\t5 - file that lists files to show (optional)")
    fatalError()
}

let beforeFileName = arguments[1]
let afterFileName = arguments[2]
let devURLBasePath = arguments[3]
let prURLBasePath = arguments[4]
let fileList = arguments.count == 6 ? arguments[5] : ""

func go() {
    guard let before = Utils.getCoverageFile(file: beforeFileName),
        let after = Utils.getCoverageFile(file: afterFileName) else {
            return
    }
    let writeLocation = Utils.getParentFileName(from: afterFileName)

    let listOfiles = Utils.load(file: fileList)

    let cc = CoverageComparison(writeLocation: writeLocation, before: before, after: after, fileList: listOfiles)
    cc.printTable(devLink: devURLBasePath, prLink: prURLBasePath)
}
go()

