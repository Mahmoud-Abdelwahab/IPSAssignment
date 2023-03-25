//
//  LessonsRepository.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 24/03/2023.
//

import Foundation

struct LessonsRepository: LessonsRepositoryType {
    
    let remoteDataSource: LessonsRemoteDataSourceType
    let localDataSource: LessonsLocalDataSourceType
    
    init(remoteDataSource: LessonsRemoteDataSourceType = LessonsRemoteDataSource(),
         LocalDataSource: LessonsLocalDataSourceType = LessonsLocalDataSource()) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = LocalDataSource
    }
    
    func fetchLessons() async throws -> [Lesson] {
        do {
            let response = try await  remoteDataSource.fetchLessons().mapToDomain()
           try localDataSource.storeLessonsLocally(lessons: response)
            return response
        } catch {
            if  (error as NSError).code == Constants.offlineErrorCode {
                /// No Internet So Fetch Lessons From Local
                ///
                debugPrint("❌: no internet")
                let cachedLessons = try localDataSource.fetchLessons().mapToLessonsDomain()
                if cachedLessons.isEmpty {
                    throw error
                }
                return cachedLessons
            }
            throw error
        }
    }
}
