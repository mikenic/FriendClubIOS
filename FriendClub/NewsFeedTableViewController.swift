//
//  NewsFeedTableViewController.swift
//  FriendClub
//
//  Created by Michael Aubie on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//
import UIKit

class NewsFeedTableViewController: UITableViewController {
    
    var posts: [Post] = []
    var dataModel:DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        posts .append(contentsOf: dataModel.postList)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.postList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedItem", for: indexPath)
        let item = posts[indexPath.row]
        //1000 = title
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.title
        //2000 = authorName
        let author = cell.viewWithTag(2000) as! UILabel
        let authorName = dataModel.findFriendWithId(id: item.createdBy).firstName + " " +
                        dataModel.findFriendWithId(id: item.createdBy).lastName
        author.text = authorName
        //3000 = contentText
        let content = cell.viewWithTag(3000) as! UITextView
        content.text = item.content
        //4000 = authorAvatar
        let authorPic = cell.viewWithTag(4000) as! UIImageView
        authorPic.image = dataModel.findFriendWithId(id: item.createdBy).avatar
        //5000 = postImage
        let postPic = cell.viewWithTag(5000) as! UIImageView
        postPic.image = item.image
        return cell
    }
}
