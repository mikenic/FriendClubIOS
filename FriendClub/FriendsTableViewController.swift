//
//  FriendsTableViewController.swift
//  FriendClub
//
//  Created by Michael Aubie on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
import UIKit

class FriendsTableViewController: UITableViewController {
    var friends: [Friend] = []
    var selectedFriend:Friend! ///might not exist .!!!
    var dataModel:DataModel!
    var profileController:FriendProfileTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends.append(contentsOf: dataModel.friendList)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        let item = friends[indexPath.row]
        let label = cell.textLabel
        label?.text = item.firstName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = friends[indexPath.row]
        profileController.currentFriend = selectedFriend
        profileController.posts = selectedFriend.posts
        print(friends[indexPath.row].firstName + "was clicked")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController =
            segue.destination as! UINavigationController
        let controller = navigationController.topViewController as!
        FriendProfileTableViewController
        profileController = controller
    }
}
