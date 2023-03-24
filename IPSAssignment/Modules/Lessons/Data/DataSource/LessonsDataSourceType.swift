//
//  LessonsDataSourceType.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 24/03/2023.
//

import Foundation

protocol LessonsDataSourceType {
    /// For getting lessons from anywhere `Remote` or `local`
    ///
    func fetchLessons() async throws -> LessonsResponse
}
