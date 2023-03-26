//
//  IPSFileManager.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 26/03/2023.
//

import Foundation

struct IPSFileManager {
    
    // MARK: - Properties
    
    static let shared = IPSFileManager()
    private let fileManager = FileManager.default
    
    private init() {}
    
    // MARK: - Public Methods
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func saveVideoToFile(at url: URL, fileName: String) throws  {
        
        let destinationURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        if fileManager.isWritableFile(atPath: destinationURL.path) {
            do {
                try fileManager.moveItem(at: url, to: destinationURL)
                debugPrint("File moved successfully ✅")
            } catch {
                debugPrint("Error moving file:", error.localizedDescription, "❌")
                throw error
            }
        }
        debugPrint("❌File is read-only❌")
        throw IPSErrors.notWritableFile
    }
    
    func getVideoURLFromCache(fileName: String, fileExtension: String) throws -> URL {
        let documentsUrl = getDocumentsDirectory()
        do {
            let videoFiles = try fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter{ $0.pathExtension == fileExtension && $0.lastPathComponent == fileName  }
            if let videoUrl = videoFiles.first {
                return videoUrl
            }
        } catch {
            debugPrint("❌: Error while enumerating files \(documentsUrl.path): \(error.localizedDescription)")
            throw IPSErrors.withMessage("\(error.localizedDescription)")
        }
        debugPrint("❌: File not found")
        throw IPSErrors.fileNotFound
    }
}
