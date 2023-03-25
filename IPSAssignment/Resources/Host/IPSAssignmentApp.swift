//
//  IPSAssignmentApp.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI
#warning("Try to Inject managedObjectContext in the Core data manager")
let managedObjectContext = PersistenceController.shared.container.viewContext

@main
struct IPSAssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            LessonsView(viewModel: LessonsViewModel())
        }
    }
}
