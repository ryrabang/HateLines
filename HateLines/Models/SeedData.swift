//
//  SeedData.swift
//  HateLines
//
//  Created by 王梦君 on 2019-11-28.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import Foundation
import Firebase

class DataGenerator {
    var db:Firestore!
    let sentences = [
        "Don’t be silly, you're going to the game!",
        "What a big boy he is!",
        "Where do you come from?",
        "Better luck next time.",
        "I like salad and green beans.",
        "Come on down!",
        "In fact, now that I think about it, it is unfair to improve society in any way whatsoever.",
        "She spread the bread with socks.",
        "Look at me right now I'm about to fall!",
        "You are the Weakest Link! Goodbye!",
        "This is obviously just a big misunderstanding.",
        "pet pigs are cleaner than dogs.",
        "I hear you have a list.",
        "They're like one big happy family.",
        "Knowledge is power.",
        "When did you open the door?",
        "What are you writing to?",
        "You're so basic!",
        "You are prudent.",
        "Shut up already, I am speaking!"
    ]
    
    init() {
        db = Firestore.firestore()
    }
    
    func seedUser() {
        let firtnames = [ "Adam", "Alex", "Aaron", "Ben", "Carl", "Dan", "David", "Edward", "Fred", "Frank", "George", "Hal", "Hank", "Ike"]
        let lastnames = [ "Anderson", "Ashwoon", "Aikin", "Bateman", "Bongard", "Bowers", "Boyd", "Cannon", "Cast", "Deitz", "Dewalt", "Ebner", "Frick", "Hancock", "Haworth"]
        let collection = db.collection("users")
        for i in 0...20 {
            let randomIndexes = (Int(arc4random_uniform(UInt32(firtnames.count))),
                                 Int(arc4random_uniform(UInt32(lastnames.count))))
            let firstname = firtnames[randomIndexes.0]
            let lastname = lastnames[randomIndexes.1]
            let name = firstname + " " + lastname
            let email = firstname + "_" + lastname + "@hatelines.com"
            let password = firstname + "@" + "password"
            let imageUrl = firstname + "@image.com"
            let verified = false
            let ID = i
            
            let user = User(ID: ID, name: name, email: email, password: password, imageUrl: imageUrl, verified: verified)
            collection.document("\(user.ID)").setData(user.dictionary)
        }
        
        
    }
    
    //    var ID: Int
    //       var userID: Int
    //       var againstID: Int
    //       var imageUrl: String
    //       var phrase: String
    //       var likes: Int
    //       var createdAt: Date
    
    func seedPost() {
        let collection = db.collection("posts")
        
        for i in 0...50 {
            let userID = Int(arc4random_uniform(UInt32(20)))
            var againstID = Int(arc4random_uniform(UInt32(20)))
            
            if userID == againstID {
                againstID = againstID == 20 ? againstID - 1 : againstID + 1
            }
            
            let randomIndexes = (Int(arc4random_uniform(UInt32(sentences.count))),
            Int(arc4random_uniform(UInt32(sentences.count))))
            
            let imageUrl = "default_url@image.com"
            let phrase = "this guy sucks! " + sentences[randomIndexes.0] + sentences[randomIndexes.1]
            let likes = Int(arc4random_uniform(UInt32(100)))
            let createdAt = generateRandomDate(daysBack: Int(arc4random_uniform(UInt32(200))))
            
            let post = Post(ID: i, userID: userID, againstID: againstID, imageUrl: imageUrl, phrase: phrase, likes: likes, createdAt: createdAt!)
            
            collection.document("\(post.ID)").setData(post.dictionary)
        }
        
    }
    
    //    var ID: Int
    //    var userID: Int
    //    var postID: Int
    //    var phrase: String
    //    var likes: Int
    //    var createdAt: Date
    func seedComment() {
        let collection = db.collection("comments")
        
        for i in 0...200 {
            let userID = Int(arc4random_uniform(UInt32(20)))
            let postID = Int(arc4random_uniform(UInt32(50)))
            
            let randomIndex = Int(arc4random_uniform(UInt32(sentences.count)))
                      
            let phrase = "Agree! Because " + sentences[randomIndex]
            let likes = Int(arc4random_uniform(UInt32(100)))
            let createdAt = generateRandomDate(daysBack: Int(arc4random_uniform(UInt32(200))))
            
            let comment = Comment(ID: i, userID: userID, postID: postID, phrase: phrase, likes: likes, createdAt: createdAt!)
            
            collection.document("\(comment.ID)").setData(comment.dictionary)
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
