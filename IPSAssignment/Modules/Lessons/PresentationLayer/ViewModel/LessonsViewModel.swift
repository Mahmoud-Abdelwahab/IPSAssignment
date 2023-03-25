//
//  LessonsViewModel.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//



import Combine
import Foundation

final class LessonsViewModel: ObservableObject {
    
    // MARK: Properties
    
    private let usecase: LessonsUseCaseType
    @Published var lessons =  [Lesson]()
    @Published var isLoading = false
    @Published var shouldShowErrorView = false
    @Published var errorMessage = ""
    // MARK: Lifecycle
    
    init(usecase: LessonsUseCaseType = LessonsUsecase()) {
        self.usecase = usecase
    }
}

extension LessonsViewModel {
    @MainActor
    func fetchLessons() async {
        isLoading = true
        shouldShowErrorView = false // TODO: - try impleement pull to refresh
        defer { isLoading = false }
        do {
            lessons = try await usecase.execute()
        } catch {
            // no need for handling error here
            showErrorView(error: error)
        }
    }
    
    private func showErrorView(error: Error) {
        if lessons.isEmpty {
            shouldShowErrorView = true
            errorMessage = error.localizedDescription
        }
    }
}
