//
//  NewsFeedTableViewController.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
