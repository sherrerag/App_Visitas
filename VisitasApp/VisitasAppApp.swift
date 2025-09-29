import SwiftUI

@main
struct VisitasAppApp: App {
    let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ProjectListView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
