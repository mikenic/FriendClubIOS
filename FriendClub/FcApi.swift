//
//  FcApi.swift
//  FriendClub
//
//  Created by IOSDev on 2017-10-31.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation
import UIKit

let BaseURL = "http://friend-club.herokuapp.com"
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
//////
struct jsonPostData: Decodable {
    let data: [jsonPost]?
}

struct jsonPost: Decodable {
    let id: Int?
    let title: String?
    let content: String?
    let longitude: Double?
    let latitude: Double?
    let image: avatar?
    let created_at: String?
    let updated_at: String?
    let user_id: Int?
}

protocol FcApiProtocol: class {
    func addFriends(friends: [jsonFriend])
    func setAvatar(friend: Friend, avatar: UIImage)
    func addPosts(posts: [jsonPost])
    func setUser()
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
                
                delegate?.setUser()
                
                
            } catch let jsonErr {
                print("error serializing json in myfriends")
            }
        }.resume()
    }
    
    
    
    
    
    
    
    static func fetchPosts(delegateController: FcApiProtocol) {
        delegate = delegateController
        let jsonUrlString = "https://friend-club.herokuapp.com/api/v1/posts"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            print("ASASASAS", data)
            do {
                
                print(data)
                let dataAsString = String(data: data, encoding: .utf8)
                print(dataAsString)
                
                let webDesc = try JSONDecoder().decode(jsonHeader.self, from: data)
                let postData = try JSONDecoder().decode(jsonPostData.self, from: data)
                delegate?.addPosts(posts: postData.data!)
            } catch let jsonErr {
                print("error serializing json in posts")
            }
            }.resume()
    }
    
    
    static func fetchAvatarImage(urlString: String, friend: Friend) {
        //let imageNameUrl = folderUrl_to_request + imageName;
        let imageNameURL = BaseURL + urlString
        
        let imageUrl: URL = URL(string: imageNameURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!;
        
        let imageUrlRequest = NSMutableURLRequest(url: imageUrl);
        print("###################")
        print("fetching ... : ", imageNameURL)
        imageUrlRequest.httpMethod = "GET";
        let urlsession = URLSession.shared
        
        let imageTask = urlsession.dataTask(with: imageUrl, completionHandler: { imageData, response, error in
            DispatchQueue.main.async {
                if (error != nil) {
                    print("image downloading error ", error)
                } else {
                    let avatar = UIImage(data: imageData!)
                    delegate?.setAvatar(friend: friend, avatar: avatar!)
                    //friend.avatar = UIImage(data: imageData!)
                    
                    //contact.image = UIImage(data: imageData!);
                    //self.tableView.reloadData();
                }
            } //dispatch
        } //completionHandler
        );//dataTaskwithUrlRequest()
        imageTask.resume();
        
    }
    
    
    static func fetchMyPosts() {
        
    }
    
    static func fetchNewsFeed() {
        
    }
    
    static func fetchFriendsPost() {
        
    }
    
}
