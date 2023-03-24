//
//  LessonDetailsViewModelType.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 24/03/2023.
//

import Combine

/// LessonDetailsViewModel Input & Output
///
public typealias LessonDetailsViewModelType = LessonDetailsViewModelInput & LessonDetailsViewModelOutput

/// LessonDetails ViewModel Input
///
public protocol LessonDetailsViewModelInput {
    func viewDidLoad()
    func nextButtonDidTapped()
}

/// LessonDetails ViewModel Output
///
public protocol LessonDetailsViewModelOutput {
    var currentLessonPublisher: AnyPublisher<Lesson?, Never> { get }
    var nextButtonIsHiddenPublisher: AnyPublisher<Bool, Never> { get }
}
