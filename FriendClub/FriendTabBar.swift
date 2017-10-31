//
//  FriendTabBar.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-26.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import UIKit

class FriendTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 { // clicked on news Feed
            
            print("tag 000")
            
            
            if self.selectedIndex == 0 {
                let tabBarController = tabBar.delegate
                    as! UITabBarController
                let destinationNavigationController =
                    tabBarController.viewControllers?[0]
                        as! UINavigationController
                let destinationController =
                    destinationNavigationController.topViewController as!
                NewsFeedTableViewController
                destinationController.posts =
                    ((tabBarController.viewControllers?[0] as!
                        UINavigationController).topViewController
                        as!NewsFeedTableViewController)
                        .dataModel.postList
            }
            else if self.selectedIndex == 1 {
                print("index was 1")
            }
            
            
            
        }
        else if item.tag == 1 { // clicked on Friends
            print("tag 111")
            if self.selectedIndex == 0 {
                let tabBarController = tabBar.delegate
                    as! UITabBarController
                let destinationNavigationController =
                    tabBarController.viewControllers?[1]
                        as! UINavigationController
                let destinationController =
                    destinationNavigationController.topViewController as!
                FriendsTableViewController
                destinationController.friends =
                    ((tabBarController.viewControllers?[0] as!
                        UINavigationController).topViewController
                        as!NewsFeedTableViewController)
                        .dataModel.friendList
            }
            else if self.selectedIndex == 1 {
            }
        }
        else if item.tag == 2 {
            print("tag was 2")
            if self.selectedIndex == 0 {
                let tabBarController = tabBar.delegate
                    as! UITabBarController
                let destinationNavigationController =
                    tabBarController.viewControllers?[2]
                        as! UINavigationController
                let destinationController =
                    destinationNavigationController.topViewController as!
                MyPostsTableViewController
                destinationController.currentUser =
                    ((tabBarController.viewControllers?[0] as!
                        UINavigationController).topViewController
                        as!NewsFeedTableViewController)
                        .dataModel.currentUser
                destinationController.dataModel =
                    ((tabBarController.viewControllers?[0] as!
                        UINavigationController).topViewController
                        as!NewsFeedTableViewController)
                        .dataModel
            }
            else if self.selectedIndex == 1 {
            }

        }
    }

}
