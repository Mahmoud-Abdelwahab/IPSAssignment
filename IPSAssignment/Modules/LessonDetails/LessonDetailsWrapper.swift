//
//  LessonDetailsWrapper.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI

/// ٍٍٍThis `Wrapper` For Wrapping the the UIKIT ViewController  into SwiftUI View
/// 
struct LessonDetailsWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = LessonDetailsViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print(context)
    }
}
