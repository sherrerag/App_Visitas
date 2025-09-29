import SwiftUI

struct VisitDetailView: View {
    @ObservedObject var visit: Visit

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(visit.date, style: .date).font(.headline)
                if let notes = visit.notes { Text(notes) }
                if let photos = visit.photos {
                    ForEach(photos, id: \ .self) { name in
                        if let ui = ImageSaver.loadImage(named: name) {
                            Image(uiImage: ui).resizable().scaledToFit().cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Visita")
    }
}
