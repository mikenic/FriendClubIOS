//
//  NewPostViewController.swift
//  FriendClub
//
//  Created by vm mac on 2017-10-26.
//  Copyright © 2017 Michael Aubie. All rights reserved.
//

import UIKit
import CoreLocation


protocol NewPostViewControllerDelegate: class {
    func newPostViewControllerDidCancel(_ controller:
        NewPostViewController)
    func newPostViewController(_ controller: NewPostViewController,
                                  didFinishAdding post: Post)
    func newPostViewController(_ controller: NewPostViewController,
                                  didFinishEditing post: Post)
    func getCurrentUser()->Friend
}

class NewPostViewController: UIViewController {
    
    var newTitle = "my new post"
    var newImage = UIImage()
    var newContent = ""
    var newDate = Date()
    var newLocation = CLLocation()
    weak var delegate: NewPostViewControllerDelegate?

    
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var contentText: UITextView!
    
    
    
    @IBAction func changeImageBtnClicked(_ sender: Any) {
    }
    
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        
        newTitle = titleText.text!
        //newImage = getCurrentImage()
        if let newText = contentText.text{
            newContent = newText
        }
        newDate = Date()///must be editable
        newLocation = CLLocation()
        
        let user = (delegate?.getCurrentUser())!
        
        let newPost = Post(title: newTitle, content: newContent, location: newLocation, image: newImage, createdBy: user.email, dateCreated: newDate)
        
        
        delegate?.newPostViewController(self, didFinishAdding: newPost)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

}
