//
//  WelcomeViewController.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController, FcApiProtocol {

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generateTestPosts()
        //FcApi.fetchData()
        //dataModel.generateTestFriend()
        //dataModel.loadData(delegate:(UIApplication.shared.delegate)
          //  as! AppDelegate)
        // if(dataModel.friendList.count <= 1){ dataModel.generateTestFriend()}
        dataModel.deleteAllData()
        FcApi.fetchFriends(delegateController: self)
       // FcApi.fetchPosts(delegateController: self)
//        dataModel.setCurrentUser()
        //dataModel.addUserToFriends()        
        //dataModel.generateTestPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabbarController = segue.destination as! UITabBarController
        let navVC = tabbarController.viewControllers?[0] as! UINavigationController
        let newsFeedVC = navVC.topViewController as! NewsFeedTableViewController
        newsFeedVC.dataModel = dataModel
        let navVC2 = tabbarController.viewControllers?[1] as! UINavigationController
        let friendsVC = navVC2.topViewController as! FriendsTableViewController
        friendsVC.dataModel = dataModel
        let navVC3 = tabbarController.viewControllers?[2] as! UINavigationController
        let myPostsVC = navVC3.topViewController as! MyPostsTableViewController
        myPostsVC.dataModel = dataModel
    }
    
    func addFriends(friends: [jsonFriend]) {
        dataModel.addJSONFriends(friends: friends)
        
        dataModel.friendList.map({
            FcApi.fetchAvatarImage(urlString: $0.avatarURLstr, friend: $0)
        })
        
        FcApi.fetchPosts(delegateController: self)
    }
    
    func setAvatar(friend: Friend, avatar: UIImage) {
        friend.avatar = avatar
        print("set friend avatar")
    }
    
    func addPosts(posts: [jsonPost]) {
        dataModel.addJSONPosts(posts: posts)
    }
    
    func setUser() {
        dataModel.setCurrentUser()
    }
    
    //////////////extention api
    /*
    func fetchFriends() {
        let jsonUrlString = "https://friend-club.herokuapp.com/api/v1/my_friends"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        print("declare")
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let newFriend = try JSONDecoder().decode(jsonFriend.self, from: data)
                
                print(newFriend)
            } catch let jsonErr {
                print("error serializing json in myfriends", jsonErr)
            }
        }.resume()
    }*/
}
