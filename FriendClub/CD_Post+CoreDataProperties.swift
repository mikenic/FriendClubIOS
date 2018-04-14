//
//  CD_Post+CoreDataProperties.swift
//  FriendClub
//
//  Created by Michael Aubie on 2017-10-29.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
//
import Foundation
import CoreData

extension CD_Post {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Post> {
        return NSFetchRequest<CD_Post>(entityName: "CD_Post")
    }
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var image: NSData?
    @NSManaged public var longitude: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var locationName: String?
    @NSManaged public var relationship: CD_Friend?
}
