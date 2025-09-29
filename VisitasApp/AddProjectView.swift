import SwiftUI

struct AddProjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    @State private var name = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Nombre del proyecto", text: $name)
            }
            .navigationTitle("Nuevo proyecto")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let p = Project(context: viewContext)
                        p.id = UUID()
                        p.name = name
                        p.createdAt = Date()
                        save()
                        isPresented = false
                    }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { isPresented = false }
                }
            }
        }
    }

    private func save() {
        do { try viewContext.save() } catch { print("Save error: \(error)") }
    }
}
