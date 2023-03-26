//
//  LessonDetailsViewModel.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import Foundation
import Combine
class LessonDetailsViewModel: ObservableObject {
    
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
            let downloadButtonStyle: DownloadButtonStyle =  currentLesson.isVideoCashed ? .offline : .download
            downloadButtonStyleSubject.send(downloadButtonStyle)
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
        //   let dummyShourtVideoURL = URL(string: "https://static.vecteezy.com/system/resources/previews/011/111/903/mp4/a-large-rooster-with-a-red-tuft-in-the-village-young-red-cockerel-rhode-island-red-barnyard-mix-beautiful-of-an-orange-rhode-island-rooster-on-a-small-farm-multicolored-feathers-video.mp4")!
#warning("DOn't forget to remove this dummy data")
        let download = DownloadManager(url: currentLesson.videoURL )
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
        do {
            try IPSFileManager.shared.saveVideoToFile(at: url, fileName: "\(currentLesson.id).mp4")
            updateIsVideoDownloadedFlagInCache()
            updateIsVideoCachedCallBack(currentLesson.id)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getVideoURLFromCache() -> URL? {
        do {
            let videoURL = try IPSFileManager.shared.getVideoURLFromCache(fileName: "\(currentLesson.id).mp4", fileExtension: "mp4")
            return videoURL
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func updateIsVideoDownloadedFlagInCache() {
        do {
            try  CoreDataManager.shared.updateIsVideoCachedFlag(with: currentLesson.id)
        } catch  {
            debugPrint("❌: ", error)
        }
    }
}
