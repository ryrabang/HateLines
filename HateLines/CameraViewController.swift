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
import Foundation
import FirebaseAuth

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
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserModel.getUser {
            [weak self](users, error) in
            if (error != nil) {
                return print(error as Any)
            }
            self?.users = users
        }
        searchTableManager = SearchTableManager(connect: searchTableView)
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
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
    }

    @IBAction func upload(_ sender: Any) {
        
            if ( searchTableManager?.getSelectedUser() == nil) {
                let alert = UIAlertController(title: "No user selected!", message: "Please select a user!", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
            } else if (comment.text == ""){
                let alert = UIAlertController(title: "No comment entered!", message: "Please input a comment!", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
            } else if (image == nil) {
                let alert = UIAlertController(title: "No image selected!", message: "Please input an image!", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
            } else {
                let user = searchTableManager?.getSelectedUser()
                let message = comment.text
                    

                //storage Reference
                let storageRef = storage.reference()

                // Data in memory
                let data = image!.jpegData(compressionQuality: 0.5)

                //metadata setting
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"

                // reference Id
                let collection = self.db.collection("posts")
                let postRef = collection.document()
                    
                // get the post id for image name
                let fileName = postRef.documentID
                // Create a reference to the file you want to upload
                let ref = storageRef.child("images/\(fileName).jpg")

                // Upload the file to the path "images/rivers.jpg"
                ref.putData(data!, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print(error as Any)
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    // You can also access to download URL after upload.
                    ref.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                          return
                        }
                        
                        
                        let currentId = Auth.auth().currentUser?.uid
                        let againstID = user!.ID
                        let imageUrl = "\(downloadURL)"
                        let phrase = message
                        let createdAt = self.generateRandomDate(daysBack: Int(arc4random_uniform(UInt32(200))))
                        
                        
                        print("postId: \(postRef.documentID)")
                        
                        let post = Post(postRef: postRef, userID: currentId!, againstID: againstID, imageUrl: imageUrl, phrase: phrase!, likes: 0, createdAt: createdAt!)
                      
                        PostModel.addPost(to: postRef, post: post)
                        }
                    }
                    
                    
                    self.tabBarController!.selectedIndex = 0;
                
            }
        
            
        

    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = -1 * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
}
