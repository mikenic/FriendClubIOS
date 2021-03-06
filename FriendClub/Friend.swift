//
//  Friend.swift
//  FriendClub
//
//  Created by Michael Aubie on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation
import UIKit


class Friend: NSObject  {
    var firstName = ""
    var lastName = ""
    var email = ""
    var avatar: UIImage? = nil
    var avatarURLstr = ""
    var posts = [Post]()
    var userId: Int?
    
    init(firstName:String, lastName:String, email:String, avatar:UIImage, avatarURLstr: String, userId:Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatar = avatar
        self.userId = userId
        self.avatarURLstr = avatarURLstr
    }
}
