//
//  LessonsView.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI
import CoreData

struct LessonsView: View {
   
   @StateObject private var viewModel = LessonsViewModel()

    var body: some View {
        NavigationStack {
            List($viewModel.lessons, id: \.id) { $lesson in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: LessonDetailsWrapper()
                        .background(IPSColors.mainBackgroundColor)
                        .navigationBarTitleDisplayMode(.inline)) {
                            EmptyView()
                        }.opacity(0.0)
                    LessonCellView(lesson: $lesson)
                }
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(IPSColors.mainBackgroundColor)
            .navigationTitle("Lessons")
        }
        .task {
           await viewModel.fetchLessons()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView()
    }
}
