//
//  WelcomeViewController.swift
//  FriendClub
//
//  Created by Michael Aubie on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
import UIKit
import CoreLocation

class WelcomeViewController: UIViewController, FcApiProtocol {
    var dataModel: DataModel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        FcApi.authenticateUser(delegateController: self, email: email, password: password)
    }
    
    
    @IBAction func signupBtnClicked(_ sender: Any) {
        //send to registration
        //let url = URL(fileURLWithPath: "http://www.google.ca")
        UIApplication.shared.open(NSURL(string:"https://friend-club.herokuapp.com/users/sign_up")! as URL)//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //adds friend and sets current user if email is equal
    func addFriends(friends: [jsonFriend]) {
        dataModel.addJSONFriends(friends: friends)
        _ = dataModel.friendList.map({
            FcApi.fetchAvatarImage(urlString: $0.avatarURLstr, friend: $0)
            if($0.email == dataModel.userEmail) {
                dataModel.currentUser = $0
            }
        })
        FcApi.fetchPosts(delegateController: self)
    }
    
    func setAvatar(friend: Friend, avatar: UIImage) {
        friend.avatar = avatar
        print("set friend avatar")
    }
    
    func addUserPosts(posts: [jsonPost]) {
        dataModel.addJSONPosts(posts: posts)
        for post in dataModel.currentUser.posts {
            var index = 0
            FcApi.fetchPostImage(urlString: post.imageURLstr, friend: dataModel.currentUser, postNumber: index)
            index += 1
        }
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
        enterButtonOutlet.isEnabled = true
    }
    
    func userAuthSuccess(email: String, token: String) {
        dataModel.setUserCreds(email: email, token: token)
        dataModel.deleteAllData()
        FcApi.fetchUserInfo(delegateController: self)
        FcApi.fetchUserPosts(delegateController: self)
        FcApi.fetchFriends(delegateController: self)
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Login Success", message: "Click Enter to Continue", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in NSLog("The \"OK\" alert occured.")
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func userAuthFailed() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Login Failed", message: "Incorrect UserName or Password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in NSLog("The \"OK\" alert occured.")
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setUser(user: jsonFriend) {
        dataModel.addJSONUser(user: user)
        FcApi.fetchAvatarImage(urlString: dataModel.currentUser.avatarURLstr, friend: dataModel.currentUser)
        FcApi.fetchUserPosts(delegateController: self)
    }
    
    func setPostImage(friend: Friend, postNumber: Int, postImage: UIImage) {
        friend.posts[postNumber].image = postImage
    }
}
