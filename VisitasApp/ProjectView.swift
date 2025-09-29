import SwiftUI

struct ProjectView: View {
    @ObservedObject var project: Project
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddVisit = false
    @State private var showShare = false

    var body: some View {
        List {
            Section(header: Text("Visitas")) {
                ForEach(project.visitsArray, id: \ .id) { visit in
                    NavigationLink(destination: VisitDetailView(visit: visit)) {
                        VisitRowView(visit: visit)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(project.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: { showingAddVisit = true }) { Image(systemName: "plus") }
                    Button(action: { showShare.toggle() }) { Image(systemName: "square.and.arrow.up") }
                }
            }
        }
        .sheet(isPresented: $showingAddVisit) {
            AddVisitView(project: project, isPresented: $showingAddVisit)
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(isPresented: $showShare) {
            let pdfData = PDFGenerator.generatePDF(project: project)
            ActivityViewController(activityItems: [pdfData])
        }
    }

    private func delete(offsets: IndexSet) {
        let visits = project.visitsArray
        offsets.map { visits[$0] }.forEach(viewContext.delete)
        save()
    }

    private func save() {
        do { try viewContext.save() } catch {
            print("Save error: \(error)")
        }
    }
}
