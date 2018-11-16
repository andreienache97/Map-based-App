//
//  Place+CoreDataProperties.swift
//  My Favourite Places
//
//  Created by Andrei Enache on 15/11/2018.
//  Copyright © 2018 Andrei Enache. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var name: String?
    @NSManaged public var lat: String?
    @NSManaged public var long: String?

}
