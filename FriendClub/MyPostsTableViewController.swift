//
//  MyPostsTableViewController.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-26.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import UIKit
import CoreLocation

class MyPostsTableViewController: UITableViewController, NewPostViewControllerDelegate {
    
    var myPosts:[Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let newLocation = CLLocation()
        let newDate = Date()
        let myAvatar = UIImage()
        
        let newPost = Post(title: "my post", content: "lalalalala", location: newLocation, image: myAvatar, createdBy: "Myself", dateCreated: newDate)
        myPosts.append(newPost)

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
        return myPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostItem", for: indexPath)
        let item = myPosts[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel //1000 = title
        label.text = item.title
        
        return cell
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewPostSegue" {
            
            print("setting delegate")
            let navigationController =
                segue.destination as! UINavigationController
            let controller = navigationController.topViewController as!
            NewPostViewController
            controller.delegate = self
            print("..set")
            //controller.creatureCategory = category
        } else if segue.identifier == "editItemSegue" {
    //        let navigationController =
    //            segue.destination as! UINavigationController
    //        let controller = navigationController.topViewController as!
    //        ItemDetailViewController
    //        controller.delegate = self
    //        controller.creatureCategory = category
    //        if let indexPath = tableView.indexPath(
    //            for: sender as! UITableViewCell) {
    //            controller.creatureToEdit = creatures[indexPath.row]
    //            controller.title = creatures[indexPath.row].title
    //        }
        }
    }
    
       
    func newPostViewController(_ controller: NewPostViewController, didFinishAdding post: Post) {
        //myPosts.append(post)
        
        
        let newRowIndex = myPosts.count
        myPosts.append(post)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        print("made it here to adding")
        
    }
        
    
    func newPostViewController(_ controller: NewPostViewController, didFinishEditing post: Post) {
        ///
    }
    
    
        
    func newPostViewControllerDidCancel(_ controller: NewPostViewController) {
            
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
