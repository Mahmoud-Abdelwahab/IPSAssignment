//
//  LessonsView.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI
import CoreData

struct LessonsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \LessonEntity.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<LessonEntity>
    var body: some View {
        NavigationStack {
            List(0..<10) { _ in
                ZStack(alignment: .leading) {
                    NavigationLink(destination:
                                    Text("Hello")
                        .navigationBarTitleDisplayMode(.inline)) {
                            EmptyView()
                        }.opacity(0.0)
                    LessonCellView(url: URL(string: "https://ipsmedia.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fb9fd02c6-f567-4e17-8bb0-27e1b07f33a6%2FiOS-design.png?id=5743fac0-7002-409a-8364-eede144c4a9a&table=block&spaceId=18c2b86f-5f00-4ff1-baf7-6be563e77c7d&width=2000&userId=&cache=v2")!)
                }
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(IPSColors.mainBackgroundColor)
            .navigationTitle("Lessons")
        }

    }

    private func addItem() {
        withAnimation {
            let newItem = LessonEntity(context: viewContext)
            newItem.title = "1: \(Date())"
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
