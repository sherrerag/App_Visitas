import Foundation
import CoreData

@objc(Project)
public class Project: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var createdAt: Date
    @NSManaged public var visits: NSSet?
}

extension Project {
    static func fetchAll() -> NSFetchRequest<Project> {
        let req = NSFetchRequest<Project>(entityName: "Project")
        req.sortDescriptors = [NSSortDescriptor(keyPath: \Project.createdAt, ascending: false)]
        return req
    }

    var visitsArray: [Visit] {
        let set = visits as? Set<Visit> ?? []
        return set.sorted { $0.date > $1.date }
    }
}

@objc(Visit)
public class Visit: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var notes: String?
    @NSManaged public var photos: [String]?
    @NSManaged public var project: Project
}
