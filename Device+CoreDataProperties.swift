//
//  Device+CoreDataProperties.swift
//  MiniBus
//
//  Created by kenkan on 14/1/2022.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var texteng: String?
    @NSManaged public var textzhone: String?
    @NSManaged public var textzhtwo: String?

}

extension Device : Identifiable {

}
