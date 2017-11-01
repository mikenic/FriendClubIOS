//
//  DataModel.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-25.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

class DataModel {
    var postList: [Post] = []
    var friendList: [Friend] = []
    var currentUser: Friend!
    
    init() {
       //addUserToFriends()
    }
    
    //add the app user as the first friend in the list
    func addUserToFriends() {
        let tmpPic = UIImage()
        let thisUser = Friend(firstName: "Max", lastName: "Power", email: "mpower@gmail.com", avatar: tmpPic, userId: 0)
        addFriend(newFriend: thisUser) // add this user as the first friend
        currentUser = friendList[0]
    }
    
    func loadData(delegate: AppDelegate) {
        var cdFriendList: [NSManagedObject] = []
        var cdPostList: [NSManagedObject] = []
        let appDelegate = delegate
        let context = appDelegate.persistentContainer
        var managedObjectContext: NSManagedObjectContext!
        managedObjectContext = context.viewContext
        
        let fetchRequest =
            NSFetchRequest<CD_Friend>(entityName: "CD_Friend")
        do {
            cdFriendList = try managedObjectContext.fetch(fetchRequest)
            print("was able to fetch friends from cd")
            importFromCoreData(cdFriendList: cdFriendList,
                               context: managedObjectContext)
            if(friendList.isEmpty != true) {
                //
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func importFromCoreData(cdFriendList: [NSManagedObject],
                            context: NSManagedObjectContext) {
        
        //deleteAllData()
        friendList = []
        if(cdFriendList.count > 0) {
            let _ = cdFriendList.map{
                var friendAvatar:UIImage? = UIImage()
                if let imageData = (($0 as! CD_Friend).avatar) {
                    if let loadedImage = UIImage(data:
                        (imageData as NSData) as Data) {
                        friendAvatar = loadedImage
                        let newCgIm = loadedImage.cgImage?.copy()
                        friendAvatar = UIImage(cgImage: newCgIm!,
                                               scale: loadedImage.scale,
                                               orientation:
                            loadedImage.imageOrientation)
                    }
                }
                
                let newFriend:Friend = Friend(firstName: ($0 as! CD_Friend).firstName!, lastName: ($0 as! CD_Friend).lastName!, email: ($0 as! CD_Friend).email!, avatar: friendAvatar!, userId: 0)
                friendList.append(newFriend)
                
                let fetchRequest =
                    NSFetchRequest<CD_Post>(entityName: "CD_Post")
                    fetchRequest.predicate = NSPredicate.init(format: "relationship = %@", $0)

                let postList = try! context.fetch(fetchRequest)
                print("size of post list " + postList.count.description)
                friendList[friendList.count-1].posts = postList.map{
                    return $0.toPost()
                }
            }
        }
    }
    
    func addNewFriendToCD(newFriend: Friend) {
        //friendList.append(newFriend)
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer
        var managedObjectContext: NSManagedObjectContext!
        managedObjectContext = context.viewContext
        
        let cdNewFriend = CD_Friend(context: managedObjectContext)
        cdNewFriend.copyFriend(newFriend: newFriend)
        appDelegate.saveContext()
    }
    
    func addPost(newPost:Post, friend: Friend) {
        postList.append(newPost)
        addPostToFriend(newPost: newPost,friend: friend)
    }
    
    func addFriend(newFriend:Friend) {
        friendList.append(newFriend)
        addNewFriendToCD(newFriend: newFriend)
    }
    
    func addJSONFriends(friends: [jsonFriend]) {
        print("!@!@##!############")
        print(friends.count, "Friends inthe list###########")
        friends.map({
            let tmpAvatar = UIImage()
            let newFriend = Friend(firstName: $0.first_name!, lastName: $0.last_name!, email: $0.email!, avatar: tmpAvatar, userId: $0.id!)
            print("adding new jsonFriend")
            addFriend(newFriend: newFriend)
            
        })
    }
    
    func addJSONPosts(posts: [jsonPost]) {
        posts.map{
            let tmpPic = UIImage()
            
            let postLocation = CLLocation()
            let postImage = UIImage()
            let dateCreated = Date()
            let userId = $0.id!
            
            let newPost = Post(title: $0.title!, content: $0.content!, location: postLocation, image: postImage, createdBy: userId.description, dateCreated: dateCreated)
            
            let author = friendList.map{
                if($0.userId == userId) {
                    addPost(newPost: newPost, friend: $0)
                    print("#################################")
                    print("added ", newPost.title, " to ", $0.firstName)
                }
            }
        }
    }
    
    func deleteAllData() {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer
        var managedObjectContext: NSManagedObjectContext!
        managedObjectContext = context.viewContext
        let fetchRequest =
            NSFetchRequest<CD_Friend>(entityName: "CD_Friend")
        let friendsToDelete = try! managedObjectContext.fetch(fetchRequest)
        
        for friend in friendsToDelete {
            managedObjectContext.delete(friend)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("could not delete")
        }
    }
    
    func generateTestFriend() {
        //addUserToFriends()
        
//        let avatarImage = UIImage()
//        let newFriend = Friend(firstName: "john", lastName: "smith", email: "johns@gmail.com", avatar: avatarImage)
//        addFriend(newFriend: newFriend)
//        let newFriend2 = Friend(firstName: "joe", lastName: "rogan", email: "joe@jre.com", avatar: avatarImage)
//        addFriend(newFriend: newFriend2)
//        let newFriend3 = Friend(firstName: "jane", lastName: "smith", email: "janes@gmail.com", avatar: avatarImage)
//        addFriend(newFriend: newFriend3)
//        let newFriend4 = Friend(firstName: "les", lastName: "claypool", email: "les@gmail.com", avatar: avatarImage)
//        addFriend(newFriend: newFriend4)
        
        //generateTestPosts()
    }
    
    func generateTestPosts() {
        let location = CLLocation()
        let image = UIImage()
        let date =  Date()
        let newPost = Post(title: "happy day", content: "what a happy day",
                           location: location, image: image,
                           createdBy: "johns@gmail.com", dateCreated: date)
        
        //addPost(newPost: newPost, friend: friendList[1]
    }
    
    func addPostToFriend(newPost: Post, friend: Friend) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer
        var managedObjectContext: NSManagedObjectContext!
        managedObjectContext = context.viewContext
        let fetchRequest = NSFetchRequest<CD_Friend>(entityName: "CD_Friend")
        fetchRequest.predicate = NSPredicate.init(format: "email = %@",
                                                  friend.email)
        let friendToAddPostTo = try! managedObjectContext.fetch(fetchRequest)
        let newCDPost = CD_Post(context: managedObjectContext)
        newCDPost.copyPost(newPost: newPost)
        newCDPost.relationship = friendToAddPostTo[0]
        friendToAddPostTo[0].addToRelationship(newCDPost)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("could not save after adding item to province")
        }
    }
    
//    func getPosts(friend: Friend) -> {
//        
//    }

}
