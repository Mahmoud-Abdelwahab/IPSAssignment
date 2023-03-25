//
//  DownloadButtonStyle.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 25/03/2023.
//

import UIKit

public enum DownloadButtonStyle {
    case download
    case offline
    
    var title: String {
        switch self {
        case .download:
           return "Download"
        case .offline:
           return "Downloaded"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .download:
            return UIImage(systemName: "icloud.and.arrow.down")
        case .offline:
            return UIImage(named: "checkmark-circle-icon")
        }
    }
    
    var tintColor : UIColor {
        switch self {
        case .download:
            return UIColor.systemBlue
        case .offline:
            return UIColor.systemGreen
        }
    }
}
