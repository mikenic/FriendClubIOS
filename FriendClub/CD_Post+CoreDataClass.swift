//
//  CD_Post+CoreDataClass.swift
//  FriendClub
//
//  Created by IOSDev on 2017-10-29.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit
import CoreLocation


@objc(CD_Post)
public class CD_Post: NSManagedObject {
    func copyPost(newPost: Post) {
        self.title = newPost.title
        self.content = newPost.content
        self.date = NSDate(timeIntervalSince1970: newPost.dateCreated.timeIntervalSince1970)
        self.latitude = newPost.location.coordinate.latitude
        self.longitude = newPost.location.coordinate.longitude
        self.locationName = ""
        
        if(newPost.image != nil) {
            self.image = (UIImageJPEGRepresentation(newPost.image!, 1) as NSData?)
        }
    }
    
    
    ////////////////////////////
    
    func toPost() -> Post {
//        let provinceListItem = ProvinceListItem()
//        provinceListItem.text = self.name
//        provinceListItem.checked = self.checked
//        provinceListItem.location = self.location
//        provinceListItem.dateVisted = self.date as Date
//        provinceListItem.rating = Int(self.rating)
//
//        provinceListItem.locationCoord =
//            CLLocation(latitude: self.latitude, longitude: self.longitude)
//        provinceListItem.image = UIImage(data: self.imageData)
//
//        return provinceListItem

        let location = CLLocation()
        let author = "myself"
        var postImage = UIImage()
        
        if(self.image != nil) {
            postImage = UIImage(data: self.image! as Data)!
        } else {
            
        }
        
        
        let postDate = Date(timeIntervalSince1970: (self.date?.timeIntervalSince1970)!)
        let post = Post(title: self.title!, content: self.content!, location: location, image: postImage, createdBy: author, dateCreated: postDate)
        
        return post
    
    }
    
}





















//////////////////////

