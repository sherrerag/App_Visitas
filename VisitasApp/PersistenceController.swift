import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Build programmatic model
        let model = NSManagedObjectModel()
        let projectEntity = NSEntityDescription()
        projectEntity.name = "Project"
        projectEntity.managedObjectClassName = "Project"

        let projectId = NSAttributeDescription()
        projectId.name = "id"
        projectId.attributeType = .UUIDAttributeType
        projectId.isOptional = false

        let projectName = NSAttributeDescription()
        projectName.name = "name"
        projectName.attributeType = .stringAttributeType
        projectName.isOptional = false

        let projectCreatedAt = NSAttributeDescription()
        projectCreatedAt.name = "createdAt"
        projectCreatedAt.attributeType = .dateAttributeType
        projectCreatedAt.isOptional = false

        projectEntity.properties = [projectId, projectName, projectCreatedAt]

        // Visit entity
        let visitEntity = NSEntityDescription()
        visitEntity.name = "Visit"
        visitEntity.managedObjectClassName = "Visit"

        let visitId = NSAttributeDescription()
        visitId.name = "id"
        visitId.attributeType = .UUIDAttributeType
        visitId.isOptional = false

        let visitDate = NSAttributeDescription()
        visitDate.name = "date"
        visitDate.attributeType = .dateAttributeType
        visitDate.isOptional = false

        let visitNotes = NSAttributeDescription()
        visitNotes.name = "notes"
        visitNotes.attributeType = .stringAttributeType
        visitNotes.isOptional = true

        let visitPhotos = NSAttributeDescription()
        visitPhotos.name = "photos"
        visitPhotos.attributeType = .transformableAttributeType
        visitPhotos.attributeValueClassName = "NSArray"
        visitPhotos.isOptional = true
        visitPhotos.valueTransformerName = NSSecureUnarchiveFromDataTransformerName

        visitEntity.properties = [visitId, visitDate, visitNotes, visitPhotos]

        // Relationship: Project <->> Visit
        let toVisits = NSRelationshipDescription()
        toVisits.name = "visits"
        toVisits.destinationEntity = visitEntity
        toVisits.minCount = 0
        toVisits.maxCount = 0 // To-Many
        toVisits.deleteRule = .cascadeDeleteRule
        toVisits.isOptional = true
        toVisits.isOrdered = false

        let toProject = NSRelationshipDescription()
        toProject.name = "project"
        toProject.destinationEntity = projectEntity
        toProject.minCount = 1
        toProject.maxCount = 1
        toProject.deleteRule = .nullifyDeleteRule
        toProject.isOptional = false
        toProject.isOrdered = false

        toVisits.inverseRelationship = toProject
        toProject.inverseRelationship = toVisits

        // Attach relationships
        projectEntity.properties.append(toVisits)
        visitEntity.properties.append(toProject)

        model.entities = [projectEntity, visitEntity]

        container = NSPersistentContainer(name: "VisitasModel", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
