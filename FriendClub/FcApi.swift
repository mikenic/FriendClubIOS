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

struct jsonToken: Decodable {
    let auth_token: String?
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

struct jsonUserData: Decodable {
    let data: jsonFriend?
}

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
    func addUserPosts(posts: [jsonPost])
    func setUser(user: jsonFriend)
    func setPostImage(friend: Friend, postNumber: Int, postImage: UIImage)
    func userAuthSuccess(email: String, token: String)
    func userAuthFailed()
}

class FcApi {
    static weak var delegate: FcApiProtocol?

    static func fetchFriends(delegateController: FcApiProtocol) {
        delegate = delegateController
        let jsonUrlString = "http://friend-club.herokuapp.com/api/v1/my_friends"
        //let urlWithParams = jsonUrlString + "?Authorization=" + DataModel.userToken
        guard let url = URL(string: jsonUrlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")

        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            guard let data = data else { return }
            do {
                _ = try JSONDecoder().decode(jsonHeader.self, from: data)
                let friendData = try JSONDecoder().decode(jsonData.self, from: data)
                delegate?.addFriends(friends: friendData.data!)
                //delegate?.setUser()
            } catch let jsonErr {
                print("error serializing json in fetch friends", jsonErr)
            }
        }.resume()
    }
    
    static func fetchPosts(delegateController: FcApiProtocol) {
        delegate = delegateController
        let jsonUrlString = "https://friend-club.herokuapp.com/api/v1/posts"
        guard let url = URL(string: jsonUrlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")

        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            guard let data = data else { return }
            do {
                _ = try JSONDecoder().decode(jsonHeader.self, from: data)
                let postData = try JSONDecoder().decode(jsonPostData.self, from: data)
                delegate?.addPosts(posts: postData.data!)
            } catch let jsonErr {
                print("error serializing json in posts", jsonErr)
            }
        }.resume()
    }
    
    static func fetchUserPosts(delegateController: FcApiProtocol) {
        delegate = delegateController
        let jsonUrlString = "https://friend-club.herokuapp.com/api/v1/my_posts"
        guard let url = URL(string: jsonUrlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            guard let data = data else { return }
            do {
                _ = try JSONDecoder().decode(jsonHeader.self, from: data)
                let postData = try JSONDecoder().decode(jsonPostData.self, from: data)
                delegate?.addUserPosts(posts: postData.data!)
            } catch let jsonErr {
                print("error serializing json in posts", jsonErr)
            }
            }.resume()
    }
    
    static func fetchAvatarImage(urlString: String, friend: Friend) {
        let imageNameURL = BaseURL + urlString
        let imageUrl: URL = URL(string: imageNameURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!;
        let imageUrlRequest = NSMutableURLRequest(url: imageUrl);
        imageUrlRequest.httpMethod = "GET";
        imageUrlRequest.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")

        
        
        let urlsession = URLSession.shared
        let imageTask = urlsession.dataTask(with: imageUrl, completionHandler: { imageData, response, error in
            DispatchQueue.main.async {
                if (error != nil) {
                    print("image downloading error ", error!)
                } else {
                    
                    
                    let avatar = UIImage(data: imageData!)
                    delegate?.setAvatar(friend: friend, avatar: avatar!)
                }
            } //dispatch
        } //completionHandler
        );//dataTaskwithUrlRequest()
        imageTask.resume();
    }
    
    static func fetchPostImage(urlString: String, friend: Friend, postNumber: Int) {
        let imageNameURL = BaseURL + urlString
        let imageUrl: URL = URL(string: imageNameURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!;
        let imageUrlRequest = NSMutableURLRequest(url: imageUrl);
        imageUrlRequest.httpMethod = "GET";
        imageUrlRequest.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")
        let urlsession = URLSession.shared
        let imageTask = urlsession.dataTask(with: imageUrl, completionHandler: { imageData, response, error in
            DispatchQueue.main.async {
                if (error != nil) {
                    print("image downloading error ", error)
                } else {
                    let postImage = UIImage(data: imageData!)
                    if(postImage != nil) {
                        delegate?.setPostImage(friend: friend, postNumber: postNumber, postImage: postImage!)
                    }
                }
            } //dispatch
        } //completionHandler
        );//dataTaskwithUrlRequest()
        imageTask.resume();
    }
    
    static func fetchUserInfo(delegateController: FcApiProtocol) {
        delegate = delegateController
        let jsonUrlString = "http://friend-club.herokuapp.com/api/v1/show"
        //let urlWithParams = jsonUrlString + "?Authorization=" + DataModel.userToken
        guard let url = URL(string: jsonUrlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            guard let data = data else { return }
            do {
                _ = try JSONDecoder().decode(jsonHeader.self, from: data)
                let friendData = try JSONDecoder().decode(jsonUserData.self, from: data)
                let user:jsonFriend = friendData.data!
                let str:String = String(data.description)
                print("\n\n\n\n\n\n\n ", str)
                print("\(data as NSData)")
                let newStr = String(data: data, encoding: String.Encoding.utf8) as String!
                print("\n\n\n ", newStr)
                
                
                print("username is: ", user.first_name)
                delegate?.setUser(user: user)
                //delegate?.addFriends(friends: friendData.data!)
                //delegate?.setUser()
            } catch let jsonErr {
                print("error serializing json in fetch friends", jsonErr)
            }
            }.resume()
    }

    
    
    static func fetchMyPosts() {
        
    }
    
    static func fetchNewsFeed() {
        
    }
    
    static func fetchFriendsPost() {
        
    }

    static func authenticateUser(delegateController: FcApiProtocol, email: String, password: String) {
        var request = URLRequest(url: URL(string: "http://friend-club.herokuapp.com/authenticate")!)
        request.httpMethod = "POST"
        let params = ["email" : email, "password" : password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) {(data:Data?, response: URLResponse?, error:Error?) in
            if let safeData = data {
                do {
                    let token = try JSONDecoder().decode(jsonToken.self, from: safeData)
                    if (token.auth_token != nil) {
                        let tokenStr:String = token.auth_token!
                        delegateController.userAuthSuccess(email: email, token: tokenStr)
                    } else {
                        
                        delegateController.userAuthFailed()
                    }
                }
                catch let jsonErr {
                    print("error serializing json in authorization ", jsonErr)
                }
            }
        }.resume()
    }
    
    
    static func sendNewPost(post: Post) {
        var request = URLRequest(url: URL(string: "https://friend-club.herokuapp.com/api/v1/create")!)
        request.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let params = ["title" : post.title, "content" : post.content, "longitude" : post.location.coordinate.longitude, "latitude" : post.location.coordinate.latitude, "image" : "someimg"] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) {(data:Data?, response: URLResponse?, error:Error?) in
            if let safeData = data {
                print(String(data: safeData, encoding: .utf8)!)
                do {
                    let token = try JSONDecoder().decode(jsonToken.self, from: safeData)
                    if (token.auth_token != nil) {
                        let tokenStr:String = token.auth_token!
                        //delegateController.userAuthSuccess(email: email, token: tokenStr)
                        print("#$#$#$\n\n\n\n\n#$#$#$#$#$#\n\n", "SUCCESSSSSS")
                    } else {
                        print("\n\n\n\n\n\n\n\n\n\n\n FAILED \n\n\n\n")
                        //delegateController.userAuthFailed()
                    }
                }
                catch let jsonErr {
                    print("error serializing json in authorization ", jsonErr)
                }
            }
            }.resume()
    }
}
