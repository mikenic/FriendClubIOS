//
//  DataModel.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation



class DataModel {
    var postList: [Post] = []
    var friendList: [Friend] = []
    
    init() {
    }
    
    func loadData() {
    }
    
    func addPost(newPost:Post) {
            postList.append(newPost)
    }
    
    func addFriend(newFriend:Friend) {
        friendList.append(newFriend)
    }
    
}
