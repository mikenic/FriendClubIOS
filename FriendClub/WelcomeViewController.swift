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
        dataModel.loadData(delegate:(UIApplication.shared.delegate)
            as! AppDelegate)
        if(dataModel.friendList.count <= 1){ dataModel.generateTestFriend()}
        
        FcApi.fetchFriends(delegateController: self)

        //dataModel.addUserToFriends()        
        //dataModel.generateTestPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func generateTestPosts() {
//        let location = CLLocation()
//        let image = UIImage()
//        let date =  Date()
//        let newPost = Post(title: "happy day", content: "what a happy day",
//                           location: location, image: image,
//                           createdBy: "jimi@hendrix.com", dateCreated: date)
//        
//        dataModel.addPost(newPost: newPost)
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabbarController = segue.destination as! UITabBarController
        let navVC = tabbarController.viewControllers?[0] as! UINavigationController
        let newsFeedVC = navVC.topViewController as! NewsFeedTableViewController
        newsFeedVC.dataModel = dataModel
    }
    
    func addFriends(friends: [jsonFriend]) {
        dataModel.addJSONFriends(friends: friends)
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
