//
//  ImageHandler.swift
//  HateLines
//
//  Created by Younhee Lee on 2019-12-04.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

class ImageHandler{
    static func uploadImage(_ image:UIImage){
        var imageURL:String
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
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
//            self.db.collection("users").addDocument(data:[
//                "image": "\(downloadURL)"
//            ]) {
//                err in
//                if let err = err {
//                    print(err)
//                }
//            }

          }
        }

    }
}
