//
//  Friend.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation
import UIKit


class Friend  {
    var firstName = ""
    var lastName = ""
    var email = ""
    var avatar = UIImage()
    
    init(firstName:String, lastName:String, email:String, avatar:UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatar = avatar
    }
}
