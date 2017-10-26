//
//  WelcomeViewController.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController {

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTestPosts()
        generateTestFriend()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateTestPosts() {
        let location = CLLocation()
        let image = UIImage()
        let date =  Date()
        let newPost = Post(title: "happy day", content: "what a happy day",
                           location: location, image: image,
                           createdBy: "jimi@hendrix.com", dateCreated: date)
        
        dataModel.addPost(newPost: newPost)
    }
    
    func generateTestFriend() {
        let avatarImage = UIImage()
        let newFriend = Friend(firstName: "john", lastName: "smith", email: "js@gmail.com", avatar: avatarImage)
        
        dataModel.addFriend(newFriend: newFriend)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabbarController = segue.destination as! UITabBarController
        let navVC = tabbarController.viewControllers?[0] as! UINavigationController
        let newsFeedVC = navVC.topViewController as! NewsFeedTableViewController
        newsFeedVC.dataModel = dataModel
    }
}