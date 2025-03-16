//
//  TodoCDEntity+CoreDataProperties.swift
//  ToDo List
//
//  Created by Глеб Капустин on 15.03.2025.
//
//

import Foundation
import CoreData


extension TodoCDEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoCDEntity> {
        return NSFetchRequest<TodoCDEntity>(entityName: "TodoCDEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var note: String?
    @NSManaged public var date: Date?
    @NSManaged public var completed: Bool

}

extension TodoCDEntity : Identifiable {

}
