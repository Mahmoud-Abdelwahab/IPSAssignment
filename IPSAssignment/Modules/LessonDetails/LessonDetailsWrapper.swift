//
//  LessonDetailsWrapper.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI

/// ٍٍٍThis `Wrapper` For Wrapping the the UIKIT ViewController  into SwiftUI View
/// 
struct LessonDetailsWrapper: UIViewControllerRepresentable {
    let currentLesson: Lesson
    let lessons: [Lesson]
    init(currentLesson: Lesson, lessons: [Lesson]) {
        self.currentLesson = currentLesson
        self.lessons = lessons
    }
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = LessonDetailsViewController(viewModel: LessonDetailsViewModel(currentLesson: currentLesson, lessons: lessons))
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print(context)
    }
}
