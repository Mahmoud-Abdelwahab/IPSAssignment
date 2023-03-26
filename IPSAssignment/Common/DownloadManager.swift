//
//  DownloadManager.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 26/03/2023.
//

import Foundation

class DownloadManager: NSObject {
    let url: URL
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    }()
    
    private var continuation: AsyncStream<Event>.Continuation?
    
    private lazy var task: URLSessionDownloadTask = {
        let task = downloadSession.downloadTask(with: url)
        task.delegate = self
        return task
    }()
    
    init(url: URL) {
        self.url = url
    }
    
    var events: AsyncStream<Event> {
        AsyncStream { continuation in
            self.continuation = continuation
            task.resume()
            continuation.onTermination = { @Sendable [weak self] _ in
                self?.task.cancel()
            }
        }
    }
    
    func cancelProcess() {
        task.cancel()
    }
}

extension DownloadManager {
    enum Event {
        case progress(currentBytes: Int64, totalBytes: Int64)
        case success(url: URL)
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        continuation?.yield( .progress(
            currentBytes: totalBytesWritten,
            totalBytes: totalBytesExpectedToWrite))
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        continuation?.yield(.success(url: location))
        continuation?.finish()
    }
}
