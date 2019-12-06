//
//  SignUpViewController.swift
//  HateLines
//
//  Created by Mohammad Salamat on 2019-12-01.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
//import FirebaseDatabase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with fields, show error message
            showError(error!)
        } else {
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fullName = firstName + " " + lastName
            
            
            //storage Reference

              let storageRef = storage.reference()

              // Data in memory (image? is UIImage)
              let data = image.jpegData(compressionQuality: 0.5)

              //metadata setting
              let metadata = StorageMetadata()
              metadata.contentType = "image/jpeg"

              // Create a reference to the file you want to upload
              let ref = storageRef.child("images/" + "heelli" + ".jpg")

              let userUID = Auth.auth().currentUser?.uid
            print("userUID: \(String(describing: userUID))")

              // Upload the file to the path "images/rivers.jpg"
              ref.putData(data!, metadata: metadata) { (metadata, error) in
//                guard let metadata = metadata else {
//                    print(error as Any)
//                  return
//                }
                // Metadata contains file metadata such as size, content-type.
                // You can also access to download URL after upload.
                ref.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        
                        return
                    }
                    let imageURL = "\(downloadURL)"
                    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                        
                        if err != nil { // Check for errors
                            self.showError("Error creating user")
                            print(err!)
                        } else { // User was created successfully
                            
                            let userUID = Auth.auth().currentUser?.uid
                            
                            // Store the rest of the user info
                            let currentUser = User(ID: userUID!, name: fullName, email: email, password: password, imageUrl: imageURL, verified: false)
                            
                            UserModel.addUser(currentUser)
                            
                            self.transitionToHome()
                        }
                    }
                }
            }
            
            // Create the user
            
        }
        
    }
    
    
    func storeImage(_ userUid: String, _ currentUser: User) {
        
        print("CLICKED SIGN UP")
        print("CLICKED SIGN UP")
        print("CLICKED SIGN UP")
        print("CLICKED SIGN UP")
        print("CLICKED SIGN UP")
        
        
        UserModel.addUser(currentUser)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.landingViewController)
        
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    
    // MARK: Camera Functions
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
        
        // for some reason .setImage(image, for: .normal) gives a blue rendering of the img,
        imageButton.setBackgroundImage(image, for: .normal)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Checks the fields to see if data is correct.
    // If everything is correct, method returns nil.
    // Otherwise, returns the error message
    func validateFields() -> String? {
        
        // Check all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        return nil
    }
    
    func transitionToHome() {
        //        let tabBarController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController)
        //
        //        view.window?.rootViewController = tabBarController
        //        view.window?.makeKeyAndVisible()
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController)
        
        self.navigationController?.pushViewController(tabBarController!, animated: true)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setUpElements() {
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
}
