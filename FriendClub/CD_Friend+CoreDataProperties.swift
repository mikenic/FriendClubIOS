//
//  CD_Friend+CoreDataProperties.swift
//  FriendClub
//
//  Created by IOSDev on 2017-10-29.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Friend> {
        return NSFetchRequest<CD_Friend>(entityName: "CD_Friend")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var avatar: NSData?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension CD_Friend {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: CD_Post)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: CD_Post)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
