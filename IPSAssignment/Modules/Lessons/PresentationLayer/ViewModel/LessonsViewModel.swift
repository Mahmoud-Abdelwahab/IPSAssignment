//
//  LessonsViewModel.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//



import Combine

final class LessonsViewModel: ObservableObject {
    
    // MARK: Properties
    
    private let usecase: LessonsUseCaseType
    private(set) var loadingSubject = PassthroughSubject<Bool, Never>()
    @Published var lessons =  [Lesson]()
    
    // MARK: Lifecycle
    
    init(usecase: LessonsUseCaseType = LessonsUsecase()) {
        self.usecase = usecase
    }
}

extension LessonsViewModel {
    @MainActor
    func fetchLessons() async {
        loadingSubject.send(true)
        defer { loadingSubject.send(false) }
        do {
            lessons = try await usecase.execute()
        } catch {
            // no need for handling error here
            debugPrint("❌ VM: \(error.localizedDescription)")
        }
    }
}
