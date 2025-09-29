import SwiftUI

struct VisitRowView: View {
    var visit: Visit

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(visit.date, style: .date)
                if let notes = visit.notes, !notes.isEmpty {
                    Text(notes).font(.caption).lineLimit(1)
                }
            }
            Spacer()
            if let photos = visit.photos, let first = photos.first, let img = ImageSaver.loadImage(named: first) {
                Image(uiImage: img).resizable().frame(width: 60, height: 60).cornerRadius(6)
            }
        }
        .padding(.vertical, 6)
    }
}
