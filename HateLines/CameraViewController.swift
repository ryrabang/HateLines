//
//  CameraViewController.swift/Users/a01043635/Desktop/HateLines/HateLines/SearchViewController.swift
//  HateLines
//
//  Created by Younhee Lee on 2019-10-10.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UISearchBarDelegate{


    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    var searchTableManager:SearchTableManager?
    var users:[User] = []
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserModel.getUser {
            [weak self](users, error) in
            if (error != nil) {
                print("error\(error)")
            }
            self?.users = users
        }
        searchTableManager = SearchTableManager(connect: searchTableView)
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchString = searchBar.text!
        
        var searchedUsers: [User] = []
        
        for user in users {
            if user.name.contains(searchString) {
                print(user.name)
                searchedUsers.append(user)
            }
        }
        searchTableManager?.updateUsers(data: searchedUsers)
        searchTableView.reloadData()
    }
    
    @IBAction func PickImages(_ sender: UIButton) {

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.CameraOn()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.GalleryOn()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        /*If you want work actionsheet on ipad
        then you have to use popoverPresentationController to present the actionsheet,
        otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    func CameraOn() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    func GalleryOn() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
        
        //        //storage Reference
        //        let storageRef = storage.reference()
        //
        //        // Data in memory
        //        let data = image?.jpegData(compressionQuality: 0.5)
        //
        //        //metadata setting
        //        let metadata = StorageMetadata()
        //        metadata.contentType = "image/jpeg"
        //
        //        // Create a reference to the file you want to upload
        //        let ref = storageRef.child("images/test.jpg")
        //
        //        // Upload the file to the path "images/rivers.jpg"
        //        let uploadTask = ref.putData(data!, metadata: metadata) { (metadata, error) in
        //          guard let metadata = metadata else {
        //            print(error)
        //            return
        //          }
        //          // Metadata contains file metadata such as size, content-type.
        //          let size = metadata.size
        //          // You can also access to download URL after upload.
        //          ref.downloadURL { (url, error) in
        //            guard let downloadURL = url else {
        //              return
        //            }
        //            self.db.collection("users").addDocument(data:[
        //                "image": "\(downloadURL)"
        //            ]) {
        //                err in
        //                if let err = err {
        //                    print(err)
        //                }
        //            }
        //
        //          }
        //        }
    }

    @IBAction func upload(_ sender: Any) {
        var user:User = (searchTableManager?.getSelectedUser())!
        var message = comment.text
        

        //storage Reference
        let storageRef = storage.reference()

        // Data in memory
        let data = image.jpegData(compressionQuality: 0.5)

        //metadata setting
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        // Create a reference to the file you want to upload
        let ref = storageRef.child("images/test.jpg")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = ref.putData(data!, metadata: metadata) { (metadata, error) in
          guard let metadata = metadata else {
            print(error)
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          ref.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
            self.db.collection("posts").addDocument(data:[
                "image": "\(downloadURL)"
            ]) {
                err in
                if let err = err {
                    print(err)
                }
            }
//let post = Post(postRef: postRef, userID: String(userID), againstID: String(againstID), imageUrl: imageUrl, phrase: phrase, likes: likes, createdAt: createdAt!)
          }
        }
    }
    
}
