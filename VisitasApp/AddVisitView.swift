import SwiftUI

struct AddVisitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var project: Project
    @Binding var isPresented: Bool

    @State private var date = Date()
    @State private var notes = ""
    @State private var showingPicker = false
    @State private var images: [UIImage] = []

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Fecha", selection: $date, displayedComponents: .date)
                Section(header: Text("Observaciones")) {
                    TextEditor(text: $notes).frame(minHeight: 100)
                }
                Section(header: Text("Fotos")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(images, id: \ .self) { img in
                                Image(uiImage: img).resizable().frame(width: 100, height: 80).cornerRadius(6)
                            }
                            Button(action: { showingPicker = true }) {
                                VStack { Image(systemName: "photo.on.rectangle.angled"); Text("Agregar") }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nueva visita")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let v = Visit(context: viewContext)
                        v.id = UUID()
                        v.date = date
                        v.notes = notes
                        v.project = project
                        // Save images to disk and store filenames
                        var names: [String] = []
                        for img in images {
                            if let name = ImageSaver.saveImage(img) {
                                names.append(name)
                            }
                        }
                        v.photos = names
                        save()
                        isPresented = false
                    }.disabled(notes.trimmingCharacters(in: .whitespaces).isEmpty && images.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { isPresented = false }
                }
            }
            .sheet(isPresented: $showingPicker) {
                ImagePicker(images: $images)
            }
        }
    }

    private func save() {
        do { try viewContext.save() } catch { print("Save error: \(error)") }
    }
}
