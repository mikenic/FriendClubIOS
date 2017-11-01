//
//  FcApi.swift
//  FriendClub
//
//  Created by IOSDev on 2017-10-31.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation

struct jsonHeader: Decodable {
    let status: String?
    let message: String?
}

struct thumb: Decodable {
    var url: String?
}

struct avatar: Decodable {
    let url: String?
    let thumb: thumb?
}
struct jsonFriend: Decodable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let avatar: avatar?
}

struct jsonData: Decodable {
    let data: [jsonFriend]?
}


protocol FcApiProtocol: class {
    func addFriends(friends: [jsonFriend])
}

class FcApi {
    static weak var delegate: FcApiProtocol?
    
    static func fetchFriends(delegateController: FcApiProtocol) {
        delegate = delegateController
        let jsonUrlString = "http://friend-club.herokuapp.com/api/v1/my_friends"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            print("DDKDKDKDKDK", data)

            do {
                //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(data)
                let dataAsString = String(data: data, encoding: .utf8)
                print(dataAsString)
                
                let webDesc = try JSONDecoder().decode(jsonHeader.self, from: data)
                print(webDesc.status)
                
                let friendData = try JSONDecoder().decode(jsonData.self, from: data)
                //print(friendData.data![0].first_name)
                
                delegate?.addFriends(friends: friendData.data!)
                
                //let newFriend = try JSONDecoder().decode(jsonFriend.self, from: data)
                
                //print(newFriend)
            } catch let jsonErr {
                print("error serializing json in myfriends")
            }
        }.resume()
    }
    
    static func fetchMyPosts() {
        
    }
    
    static func fetchNewsFeed() {
        
    }
    
    static func fetchFriendsPost() {
        
    }
    
}
