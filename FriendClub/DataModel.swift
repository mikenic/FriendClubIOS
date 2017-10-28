//
//  DataModel.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation
import UIKit


class DataModel {
    var postList: [Post] = []
    var friendList: [Friend] = []
    var currentUser: Friend!
    
    
    init() {
        let tmpPic = UIImage()
        let thisUser = Friend(firstName: "Max", lastName: "Power", email: "mpower@gmail.com", avatar: tmpPic)
        
        friendList.append(thisUser) //user is first friend
        currentUser = friendList[0]
        
        generateTestFriend()
        
        
    }
    
    func loadData() {
    }
    
    func addPost(newPost:Post) {
            postList.append(newPost)
    }
    
    func addFriend(newFriend:Friend) {
        friendList.append(newFriend)
    }
    
    
    
    
    
    func generateTestFriend() {
        let avatarImage = UIImage()
        let newFriend = Friend(firstName: "john", lastName: "smith", email: "johns@gmail.com", avatar: avatarImage)
        addFriend(newFriend: newFriend)
        
        let newFriend2 = Friend(firstName: "joe", lastName: "rogan", email: "joe@jre.com", avatar: avatarImage)
        addFriend(newFriend: newFriend2)
        
        let newFriend3 = Friend(firstName: "jane", lastName: "smith", email: "janes@gmail.com", avatar: avatarImage)
        addFriend(newFriend: newFriend3)
        
        let newFriend4 = Friend(firstName: "les", lastName: "claypool", email: "les@gmail.com", avatar: avatarImage)
        addFriend(newFriend: newFriend4)
    }
    
}
