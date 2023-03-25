//
//  LessonDetailsViewModel.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import Foundation
import Combine
class LessonDetailsViewModel: ObservableObject {
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    }()
    
    private var currentLesson: Lesson
    private let lessons: [Lesson]
    private let currentLessonSubject = CurrentValueSubject<Lesson?, Never>(nil)
    private let nextButtonIsHiddenSubject = CurrentValueSubject<Bool, Never>(true)
    private let progressSubject = PassthroughSubject<Float, Never>()
    private let showDownloadingAlertSubject = PassthroughSubject<Void, Never>()
    private var downloadButtonStyleSubject = CurrentValueSubject<DownloadButtonStyle, Never>(.download)
    private let videoURLSubject = PassthroughSubject<URL?, Never>()
    private let showErrorSubject = PassthroughSubject<String, Never>()
    private var cancelDownloadCallBack: (()-> Void)?
    private let updateIsVideoCachedCallBack: ((Int)-> Void)
    private var subscriptions = Set<AnyCancellable>()
    private let isConnected = InternetConnectionChecker.isConnectedToInternet()
    
    init(currentLesson: Lesson, lessons: [Lesson], updateIsVideoCachedCallBack: @escaping ((Int)-> Void)) {
        self.currentLesson = currentLesson
        self.lessons = lessons
        self.updateIsVideoCachedCallBack = updateIsVideoCachedCallBack
    }
}

// MARK: Inputs

extension LessonDetailsViewModel: LessonDetailsViewModelInput {
    func viewDidLoad() {
        if currentLesson.isVideoCashed { downloadButtonStyleSubject.send(.offline) }
        currentLessonSubject.send(currentLesson)
        currentLessonSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.shouldShowNextButton()
            }
            .store(in: &subscriptions)
    }
    
    func nextButtonDidTapped() {
        if let currentLessonIndex = getIndexOfCurrentLesson(), nextButtonIsHiddenSubject.value == false {
            currentLesson = lessons[currentLessonIndex+1]
            currentLessonSubject.send(currentLesson)
            downloadButtonStyleSubject.send(.download)
        }
    }
    
    func downloadButtonDidTapped() {
        if isConnected {
            Task {
                do {
                    try await downloadVideo()
                } catch {
                    print("❌: ", error)
                }
            }
        } else {
            showErrorSubject.send(" No Internet Connection .!")
        }
    }
    
    func cancelDownloadingVideo() {
        cancelDownloadCallBack?()
    }
    
    func openVideoPlayer() {
        if currentLesson.isVideoCashed {
            guard let  videoUrl = getVideoURLFromCache()  else { return }
            videoURLSubject.send(videoUrl)
        } else if isConnected  {
            videoURLSubject.send(currentLesson.videoURL)
        } else {
            videoURLSubject.send(nil)
        }
    }
}

// MARK: Outputs

extension LessonDetailsViewModel: LessonDetailsViewModelOutput {
    
    var nextButtonIsHiddenPublisher: AnyPublisher<Bool, Never> {
        nextButtonIsHiddenSubject.eraseToAnyPublisher()
    }
    
    var currentLessonPublisher: AnyPublisher<Lesson?, Never> {
        currentLessonSubject.eraseToAnyPublisher()
    }
    
    var progressPublisher: AnyPublisher<Float, Never> {
        progressSubject.eraseToAnyPublisher()
    }
    
    var showDownloadingAlertPublisher: AnyPublisher<Void, Never> {
        showDownloadingAlertSubject.first().eraseToAnyPublisher()
    }
    
    var downloadButtonStylePublisher: AnyPublisher<DownloadButtonStyle, Never> {
        downloadButtonStyleSubject.eraseToAnyPublisher()
    }
    
    var videoURLPublisher: AnyPublisher<URL?, Never> {
        videoURLSubject.eraseToAnyPublisher()
    }
    
    var showErrorPublisher: AnyPublisher<String, Never> {
        showErrorSubject.eraseToAnyPublisher()
    }
}

// MARK: Private handlers

extension LessonDetailsViewModel {
    private func shouldShowNextButton() {
        if let currentLessonIndex = getIndexOfCurrentLesson() {
            let lastLessonIndex = lessons.count - 1
            let isHidden = currentLessonIndex < lastLessonIndex ? false : true
            nextButtonIsHiddenSubject.send(isHidden)
        } else {
            nextButtonIsHiddenSubject.send(true)
        }
    }
    
    private func getIndexOfCurrentLesson() -> Int? {
        lessons.firstIndex(of: currentLesson)
    }
    
    @MainActor
    func downloadVideo() async throws {
        //        let download = DownloadManager(url: currentLesson.videoURL, downloadSession: downloadSession)
        let download = DownloadManager(url: currentLesson.videoURL, downloadSession: downloadSession)
        
        cancelDownloadCallBack = {
            download.cancelProcess()
        }
        for await event in download.events {
            showDownloadingAlertSubject.send(())
            process(event)
        }
    }
}

private extension LessonDetailsViewModel {
    func process(_ event: DownloadManager.Event) {
        switch event {
        case let .progress(current, total):
            print(current,total)
            let progress = Float(current) / Float(total)
            progressSubject.send(progress)
        case let .success(url):
            progressSubject.send(1)
            downloadButtonStyleSubject.send(.offline)
            saveFile(at: url)
        }
    }
    
    func saveFile(at url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent("\(currentLesson.id).mp4")
        
        do {
            let fileManager = FileManager.default
            
            // Create destination folder if it doesn't exist
            let folderPath = destinationURL.deletingLastPathComponent().path
            try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            
            // Move downloaded file to destination URL
            try fileManager.moveItem(at: url, to: destinationURL)
            updateIsVideoDownloadedFlagInCache()
            updateIsVideoCachedCallBack(currentLesson.id)
            print("File moved successfully")
        } catch {
            print("Error moving file:", error.localizedDescription)
        }
    }
    
    func getVideoURLFromCache() -> URL? {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let videoFiles = try fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter{ $0.pathExtension == "mp4" && $0.lastPathComponent == "\(currentLesson.id).mp4"  }
            if let videoUrl = videoFiles.first {
                return videoUrl
            } else {
                debugPrint("File not found")
            }
        } catch {
            print("Error while enumerating files \(documentsUrl.path): \(error.localizedDescription)")
        }
        return nil
    }
    
    func updateIsVideoDownloadedFlagInCache() {
        do {
            try  CoreDataManager.shared.updateIsVideoCachedFlag(with: currentLesson.id)
        } catch  {
            debugPrint("❌: ", error)
        }
    }
}


class DownloadManager: NSObject {
    let url: URL
    let downloadSession: URLSession
    
    private var continuation: AsyncStream<Event>.Continuation?
    
    private lazy var task: URLSessionDownloadTask = {
        let task = downloadSession.downloadTask(with: url)
        task.delegate = self
        return task
    }()
    
    init(url: URL, downloadSession: URLSession) {
        self.url = url
        self.downloadSession = downloadSession
    }
    
    
    var events: AsyncStream<Event> {
        AsyncStream { continuation in
            self.continuation = continuation
            task.resume()
            continuation.onTermination = { @Sendable [weak self] _ in
                ///The onTermination sendable closure will cancel the download task when the caller stops listening to the stream of events
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
