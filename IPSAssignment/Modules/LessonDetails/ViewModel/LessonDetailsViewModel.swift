//
//  LessonDetailsViewModel.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import Foundation
import Combine
class LessonDetailsViewModel: ObservableObject {
    
    private let currentLesson: Lesson
    private let lessons: [Lesson]
    var currentLessonSubject = PassthroughSubject<Lesson, Never>()
    
    init(currentLesson: Lesson, lessons: [Lesson]) {
        self.currentLesson = currentLesson
        self.lessons = lessons
        currentLessonSubject.send(currentLesson)
    }
    
}
