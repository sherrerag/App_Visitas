import SwiftUI

struct ProjectListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Project.fetchAll()) private var projects: FetchedResults<Project>

    @State private var showingAdd = false

    var body: some View {
        NavigationView {
            List {
                ForEach(projects, id: \ .id) { project in
                    NavigationLink(destination: ProjectView(project: project)) {
                        VStack(alignment: .leading) {
                            Text(project.name).font(.headline)
                            Text(project.createdAt, style: .date).font(.caption)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Proyectos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddProjectView(isPresented: $showingAdd)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func delete(offsets: IndexSet) {
        offsets.map { projects[$0] }.forEach(viewContext.delete)
        save()
    }

    private func save() {
        do { try viewContext.save() } catch {
            print("Save error: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
