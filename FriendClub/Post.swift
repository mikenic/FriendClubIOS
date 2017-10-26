//
//  Post.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class Post {
    var title = ""
    var content = ""
    var location = CLLocation()
    var image: UIImage? = nil
    var createdBy = ""
    var dateCreated = Date()
    
    
    init(title: String,  content: String, location: CLLocation, image: UIImage,
         createdBy:String, dateCreated: Date) {
        self.title = title
        self.content  = content
        self.location = location
        self.image = image
        self.createdBy = createdBy
        self.dateCreated = Date()/////dateCreated
    
    
    }
    

}
