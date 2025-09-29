import UIKit
import PDFKit
import SwiftUI

struct PDFGenerator {
    static func generatePDF(project: Project) -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842)) // A4
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            let title = "Informe de visitas - \(project.name)"
            let titleAttr: [NSAttributedString.Key:Any] = [.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
            title.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttr)

            var y: CGFloat = 60
            for visit in project.visitsArray {
                let dateStr = DateFormatter.localizedString(from: visit.date, dateStyle: .medium, timeStyle: .none)
                let header = "\(dateStr)"
                header.draw(at: CGPoint(x: 20, y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
                y += 22
                if let notes = visit.notes {
                    let textRect = CGRect(x: 20, y: y, width: 555, height: 100)
                    let attr = NSAttributedString(string: notes, attributes: [.font: UIFont.systemFont(ofSize: 12)])
                    attr.draw(in: textRect)
                    y += 60
                }
                if let photos = visit.photos {
                    for name in photos {
                        if let img = ImageSaver.loadImage(named: name) {
                            let maxW: CGFloat = 200
                            let w = min(maxW, img.size.width * (200/img.size.height))
                            let rect = CGRect(x: 20, y: y, width: w, height: 200)
                            img.draw(in: rect)
                            y += 210
                            if y > 700 { ctx.beginPage(); y = 20 }
                        }
                    }
                }
                y += 10
                if y > 700 { ctx.beginPage(); y = 20 }
            }
        }
        return data
    }
}

// Helper for sharing PDF in SwiftUI sheets
import UIKit
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
