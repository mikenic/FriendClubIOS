//
//  FriendProfileTableViewController.swift
//  FriendClub
//
//  Created by Michael Aubie on 2017-10-27.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
import UIKit

class FriendProfileTableViewController: UITableViewController {
    var currentFriend:Friend!
    var posts:[Post] = []
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        } else {
            return currentFriend.posts.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendProfile", for: indexPath)
            let friendNameText = cell.viewWithTag(1000) as!UILabel // 1000 = friend name
            friendNameText.text = currentFriend.firstName + " " + currentFriend.lastName
            let friendAvatar = cell.viewWithTag(2000) as! UIImageView // 2000 = friend avatar
            friendAvatar.image = currentFriend.avatar
            let friendEmail = cell.viewWithTag(3000) as! UILabel // 3000 = friend email
            friendEmail.text = currentFriend.email
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPost", for: indexPath)
            let postTitle = cell.viewWithTag(1000) as!UILabel // 1000 = post title
            postTitle.text = currentFriend.posts[indexPath.row].title
            let postImage = cell.viewWithTag(2000) as! UIImageView // 2000 = post image
            postImage.image = currentFriend.posts[indexPath.row].image
            let postContent = cell.viewWithTag(3000) as! UITextView // 3000 = friend content
            postContent.text = currentFriend.posts[indexPath.row].content
            let postDate = cell.viewWithTag(4000) as! UILabel // 4000 = post date
            postDate.text = currentFriend.posts[indexPath.row].dateCreated.description
            return cell
        }
    }
}
