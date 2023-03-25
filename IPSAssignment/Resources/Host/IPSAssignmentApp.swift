//
//  IPSAssignmentApp.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI
let persistenceController = PersistenceController.shared.container.viewContext

@main
struct IPSAssignmentApp: App {

    var body: some Scene {
        WindowGroup {
            let persistenceController = PersistenceController.shared.container.viewContext

            LessonsView(viewModel: LessonsViewModel())
                .environment(\.managedObjectContext, persistenceController)
        }
    }
}
