//
//  TodoData+CoreDataProperties.swift
//  todoList_
//
//  Created by 배지해 on 3/21/24.
//
//

import Foundation
import CoreData


extension TodoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoData> {
        return NSFetchRequest<TodoData>(entityName: "TodoData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isChecked: Bool
    @NSManaged public var priority: Int64
    @NSManaged public var title: String?

}

extension TodoData : Identifiable {

}
