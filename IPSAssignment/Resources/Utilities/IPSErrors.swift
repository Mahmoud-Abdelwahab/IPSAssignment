//
//  IPSErrors.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 24/03/2023.
//

import Foundation

enum IPSErrors: LocalizedError {
    /// Invalid URL
    case withMessage(String)
}

struct IPSErrorMessage: Decodable {
    let error: String
}
