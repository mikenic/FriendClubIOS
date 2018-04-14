//
//  DataModel.swift
//  FriendClub
//
//  Created by Michael Aubie on 2017-10-25.
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
    var userEmail: String!
    static var userToken: String!
    
    init() {
       //
    }
    
    func setUserCreds(email:String, token:String) {
        self.userEmail = email
        DataModel.userToken = token
    }
    
    //add the app user as the first friend in the list
    func addUserToFriends() {
        //let tmpPic = UIImage()
        //let thisUser = Friend(firstName: "Max", lastName: "Power", email: "mpower@gmail.com", avatar: tmpPic, userId: 0)
        //addFriend(newFriend: thisUser) // add this user as the first friend
        //currentUser = friendList[0]
    }
    
    func loadData(delegate: AppDelegate) {
        var cdFriendList: [NSManagedObject] = []
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
                ///////////fix has no avatarURLstr !!!!!!!!!!!!####
                let newFriend:Friend = Friend(firstName: ($0 as! CD_Friend).firstName!, lastName: ($0 as! CD_Friend).lastName!, email: ($0 as! CD_Friend).email!, avatar: friendAvatar!, avatarURLstr: "", userId: 0)
                friendList.append(newFriend)
                
                let fetchRequest =
                    NSFetchRequest<CD_Post>(entityName: "CD_Post")
                    fetchRequest.predicate = NSPredicate.init(format: "relationship = %@", $0)
                let postList = try! context.fetch(fetchRequest)
                friendList[friendList.count-1].posts = postList.map{
                    return $0.toPost()
                }
            }
        }
    }
    
    func addNewFriendToCD(newFriend: Friend) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer
        var managedObjectContext: NSManagedObjectContext!
        managedObjectContext = context.viewContext
        let cdNewFriend = CD_Friend(context: managedObjectContext)
        cdNewFriend.copyFriend(newFriend: newFriend)
        appDelegate.saveContext()
    }
    
    func addPost(newPost:Post, friend: Friend) {
        if(friend.userId != currentUser.userId) {
            postList.append(newPost)
            addPostToFriend(newPost: newPost,friend: friend)
        } else {
            currentUser.posts.append(newPost) //doesnt add to core data
            FcApi.fetchPostImage(urlString: newPost.imageURLstr, friend: currentUser, postNumber: currentUser.posts.count-1)
        }
    }
   
    func addUserPost(newPost:Post, user: Friend) {
        if(user.userId != currentUser.userId) {
        } else {
            currentUser.posts.append(newPost) //doesnt add to core data
        }
    }
    
    func addFriend(newFriend:Friend) {
        friendList.append(newFriend)
        addNewFriendToCD(newFriend: newFriend)
    }
    
    func addJSONUser(user: jsonFriend) {
        let tmpAvatar = UIImage()
        _ = user.id!
        let newUser = Friend(firstName: user.first_name!, lastName: user.last_name!, email: user.email!, avatar: tmpAvatar, avatarURLstr: (user.avatar?.url!)!, userId: user.id!)
        currentUser = newUser
    }
    
    func addJSONFriends(friends: [jsonFriend]) {
        _ = friends.map({
            let tmpAvatar = UIImage()
            let x:Int = $0.id!
            let newFriend = Friend(firstName: $0.first_name!, lastName: $0.last_name!, email: $0.email!, avatar: tmpAvatar, avatarURLstr: ($0.avatar?.url)!, userId: x)
            addFriend(newFriend: newFriend)
        })
    }
    
    func addJSONPosts(posts: [jsonPost]) {
        _ = posts.map{
            let postLocation = CLLocation()
            let postImage = UIImage()
            let dateCreated = Date()
            let userId = $0.user_id!
            let newPost = Post(title: $0.title!, content: $0.content!, location: postLocation, image: postImage, imageURLstr: ($0.image?.url)!, createdBy: userId, dateCreated: dateCreated)
            if (currentUser != nil && userId == currentUser.userId) {
                addPost(newPost: newPost, friend: currentUser)
            }
            _ = friendList.map{
                if($0.userId == userId) {
                    addPost(newPost: newPost, friend: $0)
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
    }
    
    func generateTestPosts() {
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
        if(friendToAddPostTo.count > 0) {
            let newCDPost = CD_Post(context: managedObjectContext)
            newCDPost.copyPost(newPost: newPost)
            newCDPost.relationship = friendToAddPostTo[0]
            friendToAddPostTo[0].addToRelationship(newCDPost)
            friend.posts.append(newPost)
            do {
                //try managedObjectContext.save()
            } catch {
                //print("could not save after adding item to province")
            }
        }
    }
    
    func findFriendWithId(id: Int) -> Friend! {
        let friends = friendList.filter({$0.userId == id})
        if friends.count > 0 { return friends[0]}
        return nil
    }
}
