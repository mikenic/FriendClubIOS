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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generateTestPosts()
        //FcApi.fetchData()
        //dataModel.generateTestFriend()
        //dataModel.loadData(delegate:(UIApplication.shared.delegate)
          //  as! AppDelegate)
        // if(dataModel.friendList.count <= 1){ dataModel.generateTestFriend()}
        //------------------------------
        //FcApi.authenticateUser(delegateController: self)
        //Just delete all and fetch friends
        //dataModel.deleteAllData()
        //FcApi.fetchFriends(delegateController: self
        //-------------------------
       // FcApi.fetchPosts(delegateController: self)
//        dataModel.setCurrentUser()
        //dataModel.addUserToFriends()        
        //dataModel.generateTestPosts()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        FcApi.authenticateUser(delegateController: self, email: email, password: password)
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
        _ = dataModel.friendList.map({
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
        for friend in dataModel.friendList {
            var index = 0
            for post in friend.posts {
                FcApi.fetchPostImage(urlString: post.imageURLstr, friend: friend, postNumber: index)
                index += 1
            }
        }
    }
    
    func userAuthSuccess(email: String, token: String) {
        print("\n\n\n\n\n\n ##########abab")
        print(token)
        dataModel.setUserCreds(email: "", token: token)
        dataModel.deleteAllData()
        FcApi.fetchFriends(delegateController: self)
    }
    
    func setUser() {
        dataModel.setCurrentUser()
    }
    
    func setPostImage(friend: Friend, postNumber: Int, postImage: UIImage) {
        friend.posts[postNumber].image = postImage
    }
    
}
