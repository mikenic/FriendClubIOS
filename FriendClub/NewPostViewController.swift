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
    var newImage: UIImage?
    var newContent = ""
    var newDate = Date()
    var newLocation = CLLocation()
    weak var delegate: NewPostViewControllerDelegate?
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var contentText: UITextView!
    
    @IBAction func changeImageBtnClicked(_ sender: Any) {
        pickPhoto()
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        newTitle = titleText.text!
        if let newText = contentText.text{
            newContent = newText
        }
        newDate = Date()///must be editable
        newLocation = CLLocation()
        let user = (delegate?.getCurrentUser())!
        var tmpImage:UIImage? = UIImage()
        let imageURLStr = ""
        tmpImage = postImage.image
        let newPost = Post(title: newTitle, content: newContent, location: newLocation, image: tmpImage!, imageURLstr: imageURLStr, createdBy: user.userId!, dateCreated: newDate)
        delegate?.newPostViewController(self, didFinishAdding: newPost)
        dismiss(animated: true, completion: nil)
    }
//
//    func checkPermission() {
//        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//        switch photoAuthorizationStatus {
//        case .authorized: print("Access is granted by user")
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)") if newStatus == PHAuthorizationStatus.authorized { / do stuff here */ print("success") } })
//        case .restricted: / print("User do not have access to photo album.")
//        case .denied: / print("User has denied the permission.") }
//
//    }
//
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show(image: UIImage) {
        postImage.image = image
        postImage.isHidden = false
        //postImage.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
    }
}


extension NewPostViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func pickPhoto() {
        if true || UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let takePhotoAction =
            UIAlertAction(title: "Take Photo", style: .default,
                          handler: { _ in self.takePhotoWithCamera() })
        alertController.addAction(takePhotoAction)
        let chooseFromLibraryAction =
            UIAlertAction(title: "Choose From Library",
                          style: .default, handler: { _ in self
                            .choosePhotoFromLibrary() })
        alertController.addAction(chooseFromLibraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        newImage = UIImage()
        newImage? =
            (info[UIImagePickerControllerEditedImage] as? UIImage)!
        
        if let theImage = newImage {
            show(image: theImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
