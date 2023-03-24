//
//  Lesson.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import Foundation

/// This struct represent the main lesson entity
///
struct LessonViewModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let thumbnailURL: URL
    let videoURL: URL
    /// `isVideoCashed`  Identify if the lesson video dowloaded to files or not
    ///
    let isVideoCashed = false
}
