//
//  LessonsLocalDataSource.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 24/03/2023.
//

import Foundation

protocol LessonsLocalDataSourceType {
    /// For getting lessons
    ///
    func fetchLessons() throws -> [LessonEntity]

    /// For caching lessons locally
    ///
    func storeLessonsLocally(lessons: [Lesson]) throws
    /// For Updating the isVideoCached property
    ///
    func updateLesson(lesson: Lesson) throws
}

struct LessonsLocalDataSource: LessonsLocalDataSourceType {
    func updateLesson(lesson: Lesson) throws {
        try CoreDataManager.shared.updateLesson(lesson: lesson)
    }
    
    func fetchLessons() throws -> [LessonEntity] {
        try  CoreDataManager.shared.fetchLessons()
    }
    
    func storeLessonsLocally(lessons: [Lesson]) throws {
        try CoreDataManager.shared.addLessons(lessons: lessons)
    }
}
