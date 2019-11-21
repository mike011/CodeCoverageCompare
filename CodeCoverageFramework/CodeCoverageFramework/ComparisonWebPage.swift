//
//  ComparisonWebPage.swift
//  CodeCoverageFramework
//
//  Created by Michael Charland on 2019-11-20.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class ComparisonWebPage {

    private let devLink: String
    private let prLink: String

    init(devLink: String, prLink: String) {
        self.devLink = devLink
        self.prLink = prLink
    }

    func writeToFile(url: URL) {
        do {
            try getContents().write(to: url, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }

    func getContents() -> String {
        let html = """
            <!DOCTYPE html>
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        .split {
                          height: 100%;
                          width: 50%;
                          position: fixed;
                          z-index: 1;
                          top: 0;
                          overflow-x: hidden;
                          padding-top: 20px;
                        }

                        .left {
                          left: 0;
                        }

                        .right {
                          right: 0;
                        }
                    </style>
                </head>
            <body>
                <div class="split left">
                  <iframe src="\(devLink)" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>
                </div>

                <div class="split right">
                  <iframe src="\(prLink)" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>
                </div>
            </body>
        </html>
        """
        return html
    }
}
