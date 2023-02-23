//
//  SocketClient.swift
//  FastlaneSwiftRunner
//
//  Created by Joshua Liebowitz on 7/30/17.
//

//
//  ** NOTE **
//  This file is provided by fastlane and WILL be overwritten in future updates
//  If you want to add extra functionality to this project, create a new file in a
//  new group so that it won't be marked for upgrade
//

import Foundation

public enum SocketClientResponse: Error {
    case alreadyClosedSockets
    case malformedRequest
    case malformedResponse
    case serverError
    case clientInitiatedCancelAcknowledged
    case commandTimeout(seconds: Int)
    case connectionFailure
    case success(returnedObject: String?, closureArgumentValue: String?)
}

class SocketClient: NSObject {
    enum SocketStatus {
        case ready
        case closed
    }

    static let connectTimeoutSeconds = 2
    static let defaultCommandTimeoutSeconds = 3_600 // Hopefully 1 hr is enough ¯\_(ツ)_/¯
    static let doneToken = "done" // TODO: remove these
    static let cancelToken = "cancelFastlaneRun"

    fileprivate var inputStream: InputStream!
    fileprivate var outputStream: OutputStream!
    fileprivate var cleaningUpAfterDone = false
    fileprivate let dispatchGroup: DispatchGroup = DispatchGroup()
    fileprivate let commandTimeoutSeconds: Int

    private let streamQueue: DispatchQueue
    private let host: String
    private let port: UInt32

    let maxReadLength = 65_536 // max for ipc on 10.12 is kern.ipc.maxsockbuf: 8388608 ($sysctl kern.ipc.maxsockbuf)

    private(set) weak var socketDelegate: SocketClientDelegateProtocol?

    public private(set) var socketStatus: SocketStatus

    // localhost only, this prevents other computers from connecting
    init(host: String = "localhost", port: UInt32 = 2000, commandTimeoutSeconds: Int = defaultCommandTimeoutSeconds, socketDelegate: SocketClientDelegateProtocol) {
        self.host = host
        self.port = port
        self.commandTimeoutSeconds = commandTimeoutSeconds
        self.streamQueue = DispatchQueue(label: "streamQueue")
        self.socketStatus = .closed
        self.socketDelegate = socketDelegate
        super.init()
    }

    func connectAndOpenStreams() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        streamQueue.async {
            CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, self.host as CFString, self.port, &readStream, &writeStream)

            self.inputStream = readStream!.takeRetainedValue()
            self.outputStream = writeStream!.takeRetainedValue()

            self.inputStream.delegate = self
            self.outputStream.delegate = self

            self.inputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
            self.outputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
        }

        dispatchGroup.enter()
        streamQueue.async {
            self.inputStream.open()
        }

        dispatchGroup.enter()
        streamQueue.async {
            self.outputStream.open()
        }

        let secondsToWait = DispatchTimeInterval.seconds(SocketClient.connectTimeoutSeconds)
        let connectTimeout = DispatchTime.now() + secondsToWait

        let timeoutResult = dispatchGroup.wait(timeout: connectTimeout)
        let failureMessage = "Couldn't connect to ruby process within: \(SocketClient.connectTimeoutSeconds) seconds"

        let success = testDispatchTimeoutResult(timeoutResult, failureMessage: failureMessage, timeToWait: secondsToWait)

        guard success else {
            socketDelegate?.commandExecuted(serverResponse: .connectionFailure)
            return
        }

        socketStatus = .ready
        socketDelegate?.connectionsOpened()
    }

    public func send(rubyCommand: RubyCommandable) {
        verbose(message: "sending: \(rubyCommand.json)")
        send(string: rubyCommand.json)
    }

    public func sendComplete() {
        closeSession(sendAbort: true)
    }

    private func testDispatchTimeoutResult(_ timeoutResult: DispatchTimeoutResult, failureMessage: String, timeToWait: DispatchTimeInterval) -> Bool {
        switch timeoutResult {
        case .success:
            return true
        case .timedOut:
            log(message: "Timeout: \(failureMessage)")

            if case let .seconds(seconds) = timeToWait {
                socketDelegate?.commandExecuted(serverResponse: .commandTimeout(seconds: seconds))
            }
            return false
        }
    }

    private func stopInputSession() {
        inputStream.close()
    }

    private func stopOutputSession() {
        outputStream.close()
    }

    private func sendThroughQueue(string: String) {
        streamQueue.async {
            let data = string.data(using: .utf8)!
            _ = data.withUnsafeBytes { self.outputStream.write($0, maxLength: data.count) }
        }
    }

    private func privateSend(string: String) {
        dispatchGroup.enter()
        sendThroughQueue(string: string)

        let timeoutSeconds = cleaningUpAfterDone ? 1 : commandTimeoutSeconds
        let timeToWait = DispatchTimeInterval.seconds(timeoutSeconds)
        let commandTimeout = DispatchTime.now() + timeToWait
        let timeoutResult = dispatchGroup.wait(timeout: commandTimeout)

        _ = testDispatchTimeoutResult(timeoutResult, failureMessage: "Ruby process didn't return after: \(SocketClient.connectTimeoutSeconds) seconds", timeToWait: timeToWait)
    }

    private func send(string: String) {
        guard !cleaningUpAfterDone else {
            // This will happen after we abort if there are commands waiting to be executed
            // Need to check state of SocketClient in command runner to make sure we can accept `send`
            socketDelegate?.commandExecuted(serverResponse: .alreadyClosedSockets)
            return
        }

        if string == SocketClient.doneToken {
            cleaningUpAfterDone = true
        }

        privateSend(string: string)
    }

    func closeSession(sendAbort: Bool = true) {
        socketStatus = .closed

        stopInputSession()

        if sendAbort {
            send(rubyCommand: ControlCommand(commandType: .done))
        }

        stopOutputSession()
        socketDelegate?.connectionsClosed()
    }
}

extension SocketClient: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        guard !cleaningUpAfterDone else {
            // Still getting response from server eventhough we are done.
            // No big deal, we're closing the streams anyway.
            // That being said, we need to balance out the dispatchGroups
            dispatchGroup.leave()
            return
        }

        if aStream === inputStream {
            switch eventCode {
            case Stream.Event.openCompleted:
                dispatchGroup.leave()

            case Stream.Event.errorOccurred:
                verbose(message: "input stream error occurred")
                closeSession(sendAbort: true)

            case Stream.Event.hasBytesAvailable:
                read()

            case Stream.Event.endEncountered:
                // nothing special here
                break

            case Stream.Event.hasSpaceAvailable:
                // we don't care about this
                break

            default:
                verbose(message: "input stream caused unrecognized event: \(eventCode)")
            }

        } else if aStream === outputStream {
            switch eventCode {
            case Stream.Event.openCompleted:
                dispatchGroup.leave()

            case Stream.Event.errorOccurred:
                // probably safe to close all the things because Ruby already disconnected
                verbose(message: "output stream recevied error")

            case Stream.Event.endEncountered:
                // nothing special here
                break

            case Stream.Event.hasSpaceAvailable:
                // we don't care about this
                break

            default:
                verbose(message: "output stream caused unrecognized event: \(eventCode)")
            }
        }
    }

    func read() {
        var buffer = [UInt8](repeating: 0, count: maxReadLength)
        var output = ""
        while inputStream!.hasBytesAvailable {
            let bytesRead: Int = inputStream!.read(&buffer, maxLength: buffer.count)
            if bytesRead >= 0 {
                output += NSString(bytes: UnsafePointer(buffer), length: bytesRead, encoding: String.Encoding.utf8.rawValue)! as String
            } else {
                verbose(message: "Stream read() error")
            }
        }

        processResponse(string: output)
    }

    func handleFailure(message: [String]) {
        log(message: "Encountered a problem: \(message.joined(separator: "\n"))")
        let shutdownCommand = ControlCommand(commandType: .cancel(cancelReason: .serverError))
        send(rubyCommand: shutdownCommand)
    }

    func processResponse(string: String) {
        guard string.count > 0 else {
            socketDelegate?.commandExecuted(serverResponse: .malformedResponse)
            handleFailure(message: ["empty response from ruby process"])

            return
        }

        let responseString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let socketResponse = SocketResponse(payload: responseString)
        verbose(message: "response is: \(responseString)")
        switch socketResponse.responseType {
        case .clientInitiatedCancel:
            socketDelegate?.commandExecuted(serverResponse: .clientInitiatedCancelAcknowledged)
            closeSession(sendAbort: false)

        case let .failure(failureInformation):
            socketDelegate?.commandExecuted(serverResponse: .serverError)
            handleFailure(message: failureInformation)

        case let .parseFailure(failureInformation):
            socketDelegate?.commandExecuted(serverResponse: .malformedResponse)
            handleFailure(message: failureInformation)

        case let .readyForNext(returnedObject, closureArgumentValue):
            socketDelegate?.commandExecuted(serverResponse: .success(returnedObject: returnedObject, closureArgumentValue: closureArgumentValue))
            // cool, ready for next command
        }

        dispatchGroup.leave() // should now pull the next piece of work
    }
}

// Please don't remove the lines below
// They are used to detect outdated files
// FastlaneRunnerAPIVersion [0.9.2]