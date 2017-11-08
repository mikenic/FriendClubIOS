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
                print("error serializing json in Userposts", jsonErr)
            }
            }.resume()
    }
    
    static func fetchAvatarImage(urlString: String, friend: Friend) {
        let imageNameURL = urlString
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
        let imageNameURL = urlString
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
    
    
//    static func sendNewPost(post: Post) {
//        var request = URLRequest(url: URL(string: "https://friend-club.herokuapp.com/api/v1/create")!)
//        request.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "POST"
//        //let imageData = try? JSONSerialization.data(withJSONObject: <#T##Any#>, options: <#T##JSONSerialization.WritingOptions#>)
//        let params = ["title" : post.title, "content" : post.content, "longitude" : post.location.coordinate.longitude, "latitude" : post.location.coordinate.latitude, "image" : "someimg"] as [String : Any]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        var body = Data();
//        let image = post.image!
//        let imageName = "imageName" /////////fix
//        if let imageData = UIImageJPEGRepresentation(image, 0.6) {
//            let boundary = "" ///////////////fix
//            let encodedBoundary = ("--\(boundary)\r\n").data(using: .utf8)!;
//
//            body.append(encodedBoundary)
//
//            //body.append(encodedBoundary);
//            body.append(("Content-Disposition: form-data; name=\"imagename\"\r\n\r\n").data(using: .utf8)!);
//            body.append(("\(imageName)\r\n").data(using: .utf8)!);
//
//            body.append(encodedBoundary);
//            body.append(("Content-Disposition: form-data; name=\"image\"; filename=\"\(imageName)\"\r\n").data(using: .utf8)!);
//            body.append(("Content-Type: image/jpeg\r\n\r\n").data(using: .utf8)!);
//            body.append(imageData);
//            body.append(("\r\n").data(using: .utf8)!);
//            body.append(encodedBoundary)
//        }
//
//
//
////        if let imgname = contact.imageName, let image = contact.image, let imageData = UIImageJPEGRepresentation(image, 0.6)  {
////            body.append(encodedBoundary);
////            body.append(("Content-Disposition: form-data; name=\"imagename\"\r\n\r\n").data(using: .utf8)!);
////            body.append(("\(imgname)\r\n").data(using: .utf8)!);
////
////            body.append(encodedBoundary);
////            body.append(("Content-Disposition: form-data; name=\"image\"; filename=\"\(imgname)\"\r\n").data(using: .utf8)!);
////            body.append(("Content-Type: image/jpeg\r\n\r\n").data(using: .utf8)!);
////            body.append(imageData);
////            body.append(("\r\n").data(using: .utf8)!);
////        }
//
//
//
//        URLSession.shared.dataTask(with: request) {(data:Data?, response: URLResponse?, error:Error?) in
//            if let safeData = data {
//                print(String(data: safeData, encoding: .utf8)!)
//                do {
//                    let token = try JSONDecoder().decode(jsonToken.self, from: safeData)
//                    if (token.auth_token != nil) {
//                        let tokenStr:String = token.auth_token!
//                        //delegateController.userAuthSuccess(email: email, token: tokenStr)
//                        print("#$#$#$\n\n\n\n\n#$#$#$#$#$#\n\n", "SUCCESSSSSS")
//                    } else {
//                        print("\n\n\n\n\n\n\n\n\n\n\n FAILED \n\n\n\n")
//                        //delegateController.userAuthFailed()
//                    }
//                }
//                catch let jsonErr {
//                    print("error serializing json in authorization ", jsonErr)
//                }
//            }
//            }.resume()
//    }







































    static func sendNewPost(post: Post) {
        
        
////        let request = urlRequest(url_to_request)
//      var request = URLRequest(url: URL(string: "https://friend-club.herokuapp.com/api/v1/posts")!)
//
//        //var request = URLRequest(url: URL(string: "https://friend-club.herokuapp.com/posts")!)
//
//
//        request.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")
//
//        request.addValue("INSERT", forHTTPHeaderField: "operation")    ////POST??? insert
//
//        let session = URLSession.shared
//        request.httpMethod = "POST"
//
//        let boundary = "FieldBoundary"
//
//        let encodedData = encodeData(post, boundary)
//        //let contentType = "multipart/form-data; boundary=\(boundary)";
//        let contentType = "application/json; boundary=\(boundary)";
//        request.addValue(contentType, forHTTPHeaderField: "Content-Type");
//        request.httpBody = encodedData
//
//
//        let task = session.uploadTask(
//            with: request as URLRequest, from: encodedData, completionHandler:{
//                resultdata, response, error in
//                guard let data = resultdata, let _ = response, error == nil else {
//                    print("error")
//                    return
//                }
//                DispatchQueue.main.async{
//                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//                    print(dataString!)
//                }//DispatchQueue--may not be necessary
//        })
//        task.resume()
        
        
        
        
        
        
        
        
        

        var request = URLRequest(url: URL(string: "https://friend-club.herokuapp.com/api/v1/posts")!)
        request.addValue("Token \(DataModel.userToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        //let imageData = try? JSONSerialization.data(withJSONObject: <#T##Any#>, options: <#T##JSONSerialization.WritingOptions#>)
       
        
        let postImage = UIImageJPEGRepresentation(post.image!, 0.6)!
        let base64Image = postImage.base64EncodedString(options: .lineLength64Characters)
        //let base64Image = postImage.base64EncodedString()
    
        let fullImageString = "data:image/jpeg;base64,\(base64Image)"
        //let fullImageString = base64Image
        
        let params = ["title" : post.title, "content" : post.content, "longitude" : post.location.coordinate.longitude, "latitude" : post.location.coordinate.latitude, "image" : fullImageString] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        print("\n\n\n\n\n\n WWWWWWWWWWWWW")
        print(fullImageString)
        print("\n\n")
        print(request.httpBody?.description)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request.httpBody?.description)
      
        var body = Data();
        let image = post.image!
        let imageName = "imageName" /////////fix
//        if let imageData = UIImageJPEGRepresentation(image, 0.6) {
//            let boundary = "" ///////////////fix
//            let encodedBoundary = ("--\(boundary)\r\n").data(using: .utf8)!;
//
//            body.append(encodedBoundary)
//
//            //body.append(encodedBoundary);
//            body.append(("Content-Disposition: form-data; name=\"imagename\"\r\n\r\n").data(using: .utf8)!);
//            body.append(("\(imageName)\r\n").data(using: .utf8)!);
//
//            body.append(encodedBoundary);
//            body.append(("Content-Disposition: form-data; name=\"image\"; filename=\"\(imageName)\"\r\n").data(using: .utf8)!);
//            body.append(encodedBoundary);
//
//            body.append(("Content-Type: image/jpeg\r\n\r\n").data(using: .utf8)!);
//            body.append(imageData);
//            body.append(("\r\n").data(using: .utf8)!);
//            body.append(encodedBoundary)
//        }



        //        if let imgname = contact.imageName, let image = contact.image, let imageData = UIImageJPEGRepresentation(image, 0.6)  {
        //            body.append(encodedBoundary);
        //            body.append(("Content-Disposition: form-data; name=\"imagename\"\r\n\r\n").data(using: .utf8)!);
        //            body.append(("\(imgname)\r\n").data(using: .utf8)!);
        //
        //            body.append(encodedBoundary);
        //            body.append(("Content-Disposition: form-data; name=\"image\"; filename=\"\(imgname)\"\r\n").data(using: .utf8)!);
        //            body.append(("Content-Type: image/jpeg\r\n\r\n").data(using: .utf8)!);
        //            body.append(imageData);
        //            body.append(("\r\n").data(using: .utf8)!);
        //        }



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


    static func encodeData(_ post: Post, _ boundary: String) -> Data {
        let encodedBoundary = ("--\(boundary)\r\n").data(using: .utf8)!;
        var body = Data();
        //starting the multipart entity
        
//        let params = ["title" : post.title, "content" : post.content, "longitude" : post.location.coordinate.longitude, "latitude" : post.location.coordinate.latitude, "image" : "someimg"
//
        
        
        
        body.append(encodedBoundary)
        body.append(("Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: .utf8)!)
        body.append(("\(post.title)\r\n").data(using: .utf8)!)
        body.append(encodedBoundary)
        
        body.append(("Content-Disposition: form-data; name=\"content\"\r\n\r\n").data(using: .utf8)!)
        body.append(("\(post.content)\r\n").data(using: .utf8)!)
        body.append(encodedBoundary)
        
        body.append(("Content-Disposition: form-data; name=\"longitude\"\r\n\r\n").data(using: .utf8)!)
        body.append(("\(post.location.coordinate.longitude)\r\n").data(using: .utf8)!)
        body.append(encodedBoundary)
            
        body.append(("Content-Disposition: form-data; name=\"latitude\"\r\n\r\n").data(using: .utf8)!)
        body.append(("\(post.location.coordinate.latitude)\r\n").data(using: .utf8)!)
        
//        body.append(("Content-Disposition: form-data; name=\"phone\"\r\n\r\n").data(using: .utf8)!);
//        body.append(("\(contact.phone!)\r\n").data(using: .utf8)!);
//
        let imageName = post.title.trimmingCharacters(in: .whitespaces)
        if let image = post.image, let imageData = UIImageJPEGRepresentation(image, 0.6)  {
//            body.append(encodedBoundary);
//            body.append(("Content-Disposition: form-data; name=\"imagename\"\r\n\r\n").data(using: .utf8)!);
//            body.append(("\(imageName)\r\n").data(using: .utf8)!);
//
            body.append(encodedBoundary);
            body.append(("Content-Disposition: form-data; name=\"image\"; filename=\"\(imageName)\"\r\n").data(using: .utf8)!);
            body.append(("Content-Type: image/jpeg\r\n\r\n").data(using: .utf8)!);
            body.append(imageData);
            body.append(("\r\n").data(using: .utf8)!);
        }
        body.append(encodedBoundary);
        return body
    }







    










}

