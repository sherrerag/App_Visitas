import UIKit

struct ImageSaver {
    static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func saveImage(_ image: UIImage) -> String? {
        let id = UUID().uuidString
        let name = "\(id).jpg"
        let url = documentsDirectory().appendingPathComponent(name)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: url)
            return name
        } catch {
            print("Image save error: \(error)")
            return nil
        }
    }

    static func loadImage(named: String) -> UIImage? {
        let url = documentsDirectory().appendingPathComponent(named)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
