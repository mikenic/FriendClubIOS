//
//  CD_Friend+CoreDataClass.swift
//  FriendClub
//
//  Created by IOSDev on 2017-10-29.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(CD_Friend)
public class CD_Friend: NSManagedObject {
    func copyFriend(newFriend: Friend) {
        self.firstName = newFriend.firstName
        self.lastName = newFriend.lastName
        self.email = newFriend.email
        
        if(newFriend.avatar != nil) {
            self.avatar = (UIImageJPEGRepresentation(newFriend.avatar!, 1) as NSData?)
        }
    }
}
