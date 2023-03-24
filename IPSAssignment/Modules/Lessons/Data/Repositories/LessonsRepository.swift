//
//  LessonsRepository.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 24/03/2023.
//

import Foundation

struct LessonsRepository: LessonsRepositoryType {
    
    let remoteDataSource: LessonsDataSourceType
    let LocalDataSource: LessonsLocalDataSourceType
    
    init(remoteDataSource: LessonsDataSourceType = LessonsRemoteDataSource(),
         LocalDataSource: LessonsLocalDataSourceType = LessonsLocalDataSource()) {
        self.remoteDataSource = remoteDataSource
        self.LocalDataSource = LocalDataSource
    }
    
    func fetchLessons() async throws -> [Lesson] {
        do {
            let response = try await  remoteDataSource.fetchLessons().mapToDomain()
            return response
            /// cach it locallay
        } catch {
            if let error = error as? IPSErrors, case .offline(_) = error {
                /// No Internet So Fetch Lessons From Local
                ///
                debugPrint("❌: no internet")
                return try await LocalDataSource.fetchLessons().mapToDomain()
            }
            throw error
        }
    }
}
