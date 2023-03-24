//
//  LessonsLocalDataSource.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 24/03/2023.
//

import Foundation

protocol LessonsLocalDataSourceType: LessonsDataSourceType {
    /// For caching lessons locally
    ///
    func storeLessonsLocally()
}

struct LessonsLocalDataSource: LessonsLocalDataSourceType {

    func fetchLessons() async throws -> LessonsResponse {
        LessonsResponse.init(lessons: [])
    }
    
    func storeLessonsLocally() {
     
    }

}

