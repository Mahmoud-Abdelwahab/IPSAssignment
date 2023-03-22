//
//  IPSAssignmentApp.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI

@main
struct IPSAssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LessonsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
