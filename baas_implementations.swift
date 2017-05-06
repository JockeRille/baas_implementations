//
//  baas_implementations.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-06.
//  Copyright © 2017 Rikard Olsson & Joacim Florén. All rights reserved.
//

import UIKit
import KiiSDK
import Kinvey
import KumulosSDK
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CloudMine

/******** KII *********/

func kii_login_user(_ username: String,_ password: String) {
    do{
        try KiiUser.authenticateSynchronous(username, withPassword: password)
    }catch let error as NSError {
        // Handle the error.
    }
}

func kii_register_user(username: String, password: String) {
    
    let user = KiiUser(username: username, andPassword: password)
    
    do {
        try user.performRegistrationSynchronous()
    } catch let error as NSError {
        // Handle error
    }
}

func kii_create_post(title: String, message: String) {
    
    // Init a private post bucket
    let post_bucket = Kii.bucket(withName: "post")
    
    // Init new post
    let post = post_bucket.createObject()
    
    // Set key value
    post.setObject(title, forKey: "title")
    post.setObject(message, forKey: "message")
    
    do{
        try post.saveSynchronous()
    } catch let error as NSError {
        // Handle the error.
    }
}

func kii_create_comment(post_id: String, message: String) {
    // Init a private post bucket
    let comment_bucket = Kii.bucket(withName: "comment")
    
    // Init new post
    let comment = comment_bucket.createObject()
    
    // Set key value
    comment.setObject(post_id, forKey: "postID")
    comment.setObject(message, forKey: "message")
    
    do{
        try comment.saveSynchronous()
    } catch let error as NSError {
        // Handle the error.
    }
}

func kii_get_posts() -> [KiiPost]? {
    
    // Prepare the target bucket to be queried.
    let bucket = Kii.bucket(withName: "post")
    
    // Create a query that returns all KiiObjects.
    let allQuery = KiiQuery(clause: nil)
    
    do{
        // Query KiiObjects.
        let results = try bucket.executeQuerySynchronous(allQuery, nextQuery: nil)
        
        // Do something with the result.
        if !results.isEmpty {
            print("Got posts")
            
            var posts = [KiiPost]()
            
            for result in results {
                let kiiPostObj = result as! KiiObject
                
                let title = kiiPostObj.getForKey("title") as! String
                let message = kiiPostObj.getForKey("message") as! String
                let post_id = kiiPostObj.uuid!
                let uri = kiiPostObj.objectURI!
                
                let post = KiiPost(id: post_id, title: title, message: message, uri: uri)
                
                posts.append(post)
            }
            
            return posts
        } else {
            // Handle empty results
        }
        
    } catch let error as NSError {
        // Handle the error.
    }
    
    return nil
}

func kii_get_post(post_id: String, _ withComments: Bool) {
    
    // Instantiate a KiiObject in a bucket "_app_bucket_" in the application scope.
    let bucket = Kii.bucket(withName: "_app_bucket_")
    
    // Init object
    let object = bucket.createObject(withID: post_id)
    
    do {
        // Refresh the KiiObject to retrieve the latest data from Kii Cloud.
        try object.refreshSynchronous()
        
        let title = object.getForKey("title") as! String
        let message = object.getForKey("message") as! String
        let post_id = object.uuid!
        let uri = object.objectURI!
        
        let post = KiiPost(id: post_id, title: title, message: message, uri: uri)
        
        if withComments {
            post.comments = kii_get_comments(post_id)
        }
        
    } catch let error as NSError {
        // Handle the error.
    }
}

func kii_get_comments(_ byPostId: String) -> [KiiComment]? {
    
    // Prepare the target bucket to be queried.
    let bucket = Kii.bucket(withName: "comment")
    
    // Where query clause to get by post_id
    let clause = KiiClause.equals("postID", value: byPostId)
    
    // Create a query that returns all KiiObjects.
    let allQuery = KiiQuery(clause: clause)
    
    do{
        // Query KiiObjects.
        let results = try bucket.executeQuerySynchronous(allQuery, nextQuery: nil)
        
        // Do something with the result.
        if !results.isEmpty {
            print("Got comments")
            
            var comments = [KiiComment]()
            
            for result in results {
                let kiiCommentObj = result as! KiiObject
                
                let post_id = kiiCommentObj.getForKey("postID") as! String
                let message = kiiCommentObj.getForKey("message") as! String
                let comment_id = kiiCommentObj.uuid!
                let uri = kiiCommentObj.objectURI!
                
                let comment = KiiComment(id: comment_id, post_id: post_id, message: message, uri: uri)
                
                comments.append(comment)
            }
            
            return comments
        } else {
            print("Comment result is empty")
        }
        
    } catch let error as NSError {
        // Handle the error.
        return nil
    }
    
    return nil
}

func kii_update_comment(comment_uri: String, message: String) {
    // Instantiate a KiiObject.
    let object = KiiObject(uri: comment_uri)!
    
    do{
        // Refresh the KiiObject to retrieve the latest key-value pairs.
        try object.refreshSynchronous()
    } catch let error as NSError {
        // Handle the error.
        return
    }
    
    // Update key-value pairs.
    object.setObject(message, forKey: "message")
    
    do{
        // Save and fully update the KiiObject.
        // This method removes all key-value pairs from the KiiObject on the server and
        // adds the key-value pairs generated locally to the KiiObject.
        try object.saveAllFieldsSynchronous(false)
    } catch let error as NSError {
        // Handle the error.
    }
}

func kii_delete_comment(comment_uri: String) {
    // Instantiate a KiiObject with its URI.
    let object = KiiObject(uri: comment_uri)!
    
    do{
        // Delete the KiiObject.
        try object.deleteSynchronous()
    } catch let error as NSError {
        // Handle the error.
    }
}


/******** Kinvey *********/

func kinvey_login_user(username: String, password: String) {
    User.login(username: username, password: password) { user, error in
        if let user = user {
            // Do somehting with user
        } else {
            // Handle error
        }
    }
}

func kinvey_register_user(username: String, password: String) {
    User.signup(username: username, password: password) { user, error in
        if let user = user {
            // Do somehting with user
        } else {
            // Handle error
        }
    }
}

func kinvey_create_post(title: String, message: String) {
    
    let dataStore = DataStore<KinveyPost>.collection()
    
    let post = KinveyPost()
    post.title = title
    post.message = message
    
    dataStore.save(post) { saved_post, error in
        if let saved_post = saved_post {
            // Do something with post
        } else {
            // Handle error
        }
    }
}

func kinvey_create_comment(postId: String, message: String, _ callback: @escaping (_ comment: KinveyComment?, _ error: Swift.Error?) -> Void) {
    let dataStore = DataStore<KinveyComment>.collection()
    
    let comment = KinveyComment()
    comment.message = message
    comment.postId = postId
    
    dataStore.save(comment) { saved_comment, error in
        if let saved_comment = saved_comment {
            // Do something with comment
        } else {
            // Handle error
        }
    }
}

func kinvey_get_posts(_ callback: @escaping (_ posts: [KinveyPost]?, _ error: Swift.Error?) -> Void) {
    let dataStore = DataStore<KinveyPost>.collection()
    
    dataStore.find() { posts, error in
        if let posts = posts {
            // Do something with posts
        } else {
            // Handle error
        }
    }
}

func kinvey_get_post(byId: String, withComments: Bool = false) {
    
    let dataStore = DataStore<KinveyPost>.collection()
    
    dataStore.find(byId: byId) { post, error in
        if let post = post {
            if withComments {
                kinvey_get_comments(byPostId: post.entityId!) { comments, error in
                    if let comments = comments {
                        post.comments = comments
                        // Do something with post and comments
                    } else {
                        // Handle error
                    }
                }
            } else {
                // Do something with post
            }
        } else {
            // Handle post error
        }
    }
    
}

func kinvey_update_comment(commentId: String, message: String, _ callback: @escaping (_ comment: KinveyComment?, _ error: Swift.Error?) -> Void) {
    
    let dataStore = DataStore<KinveyComment>.collection()
    
    dataStore.find(commentId) { comment, error in
        if let comment = comment {
            
            // Update message
            comment.message = message
            
            dataStore.save(comment) { comment, error in
                if let comment = comment {
                    // Do something with updated comment
                } else {
                    // Handle error
                }
            }
        } else {
            // Handle error
        }
    }
    
}

func kinvey_get_comments(byPostId: String, _ callback: @escaping (_ comments: [KinveyComment]?, _ error: Swift.Error?) -> Void) {
    let dataStore = DataStore<KinveyComment>.collection()
    
    let query = Query(format: "postId == %@", byPostId)
    
    dataStore.find(query) { comments, error in
        if let comments = comments {
            callback(comments, error)
        } else {
            // Handle error
        }
    }
}

func kinvey_delete_comment(byCommentId: String, _ callback: @escaping (_ count: Int?, _ error: Swift.Error?) -> Void) {
    let dataStore = DataStore<KinveyComment>.collection()
    
    dataStore.removeById(byCommentId) { count, error in
        if error == nil {
            // Do something after deletion
        } else {
            // Handle error
        }
    }
}


/******** Kumulos *********/
func kumulos_login_user(username: String, password: String) {
    Kumulos.call("login", parameters: ["username": username as AnyObject, "password": password as AnyObject]).success {
        response, operation in
        
        if let object = response.payload?[0] as? AnyObject {
            let ID = object["userID"] as! UInt
            let username = object["username"] as! String
            
            let currentUser = KumulosUser(ID: ID, username: username)
        } else {
            // Handle error
        }
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_register_user(username: String, password: String) {
    Kumulos.call("register", parameters: ["username": username as AnyObject, "password": password as AnyObject]).success {
        response, operation in
        
        if let id = response.payload as? UInt {
            // Handle registered ID
        } else {
            // Handle error
        }
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_get_post(byID: UInt, _ withComments: Bool = false) {
    Kumulos.call("get_post", parameters: ["postID": byID as AnyObject]).success { response, operation in
        
        if let object = response.payload?[0] as? AnyObject {
            
            let ID = object["postID"] as! UInt
            let userID = object["userID"] as! UInt
            let title = object["title"] as! String
            let message = object["message"] as! String
            
            // Do something with post
            let post = KumulosPost(ID: ID, userID: userID, title: title, message: message)
            
            if withComments {
                kumulos_get_comments(byPostID: post.ID!) {
                    comments in
                    
                    if let comments = comments {
                        post.comments = comments
                        
                        // Do something with post including comments
                    } else {
                        // Handle when no comments
                    }
                }
            }
            
        } else {
            // Handle error
        }
        
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_get_posts() {
    
    Kumulos.call("get_posts").success { response, operation in
        
        if let objects = response.payload as? [AnyObject] {
            var posts = [KumulosPost]()
            
            for object in objects {
                let ID = object["postID"] as! UInt
                let userID = object["userID"] as! UInt
                let title = object["title"] as! String
                let message = object["message"] as! String
                
                posts.append(KumulosPost(ID: ID, userID: userID, title: title, message: message))
            }
            
            // Do something with posts
            
        } else {
            // Handle error
        }
        
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_get_comments(byPostID: UInt, _ callback: @escaping (_ comments: [KumulosComment]?) -> Void) {
    Kumulos.call("get_comments", parameters: ["postID": byPostID as AnyObject]).success {
        response, operation in
        
        if let objects = response.payload as? [AnyObject] {
            var comments = [KumulosComment]()
            
            for object in objects {
                let ID = object["commentID"] as! UInt
                let userID = object["userID"] as! UInt
                let postID = object["postID"] as! UInt
                let message = object["message"] as! String
                
                comments.append(KumulosComment(ID: ID, postID: postID, userID: userID, message: message))
            }
            
            callback(comments)
        } else {
            // Handle error
            callback(nil)
        }
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_create_post(userID: UInt, title: String, message: String) {
    Kumulos.call("create_post", parameters: ["userID": userID as AnyObject, "title": title as AnyObject, "message": message as AnyObject]).success {
        response, operation in
        
        if let postID = response.payload as? UInt {
            // Do something with created postID
        } else {
            // Handle error
        }
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_create_comment(userID: UInt, postID: UInt, message: String) {
    Kumulos.call("create_comment", parameters: ["userID": userID as AnyObject, "postID": postID as AnyObject, "message": message as AnyObject]).success {
        response, operation in
        
        if let commentID = response.payload as? UInt {
            // Do something with created commentID
        } else {
            // Handle error
        }
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_update_comment(byID: UInt, message: String) {
    Kumulos.call("update_comment", parameters: ["commentID": byID as AnyObject, "message": message as AnyObject]).success {
        response, operation in
        
        if let number_of_updated_rows = response.payload as? UInt {
            // Do something when updated
        } else {
            // Handle error
        }
        
        }.failure { (error, operation) in
            // Handle request error
    }
}

func kumulos_delete_comment(byID: UInt) {
    Kumulos.call("delete_comment", parameters: ["commentID": byID as AnyObject]).success {
        response, operation in
        
        if let number_of_deleted_rows = response.payload as? UInt {
            // Do something when updated
        } else {
            // Handle error
        }
        
        }.failure { (error, operation) in
            // Handle request error
    }
}



/******** Firebase *********/

func firebase_login_user(email: String, password: String) {
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
        if let user = user {
            // Do something with logged in user
        } else {
            // Handle error
        }
    }
}

func firebase_register_user(email: String, password: String) {
    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
        if let user = user {
            // Do something with user
        } else {
            // Handle error
        }
    }
}

// This keep track of posts with its comments. No need for get_post, get_posts or get_comments
func firebase_register_observers() {
    let ref = FIRDatabase.database().reference()
    
    ref.child("posts").observe(.value, with: { (snapshot) in
        let postDict = snapshot.value as? [String : AnyObject] ?? [:]
        
        var posts = [FirebasePost]()
        
        for (uid, object) in postDict {
            let title = object["title"] as? String ?? ""
            let message = object["message"] as? String ?? ""
            let post = FirebasePost(uid: uid, title: title, message: message)
            
            let commentDict = object["comments"] as? [String : AnyObject] ?? [:]
            
            post.comments = [FirebaseComment]()
            
            for (cuid, cobject) in commentDict {
                let message = cobject["message"] as? String ?? ""
                
                post.comments?.append(FirebaseComment(uid: cuid, post: post, message: message))
            }
            
            posts.append(post)
        }
        
        // Add posts to scope // self.posts = posts
    })
}


func firebase_create_post(title: String, message: String) {
    let ref = FIRDatabase.database().reference()
    
    ref.child("posts").childByAutoId().setValue(["title": title, "message": message])
}

func firebase_create_comment(byPostId: String, message: String) {
    let ref = FIRDatabase.database().reference()
    
    ref.child("posts/\(byPostId)/comments").childByAutoId().setValue(["message": message])
}

func firebase_update_comment(byPostId: String, andCommentId: String, message: String) {
    let ref = FIRDatabase.database().reference()
    
    let comment = ["message": message]
    let childUpdates = ["/posts/\(byPostId)/comments/\(andCommentId)": comment]
    
    ref.updateChildValues(childUpdates)
}

func firebase_delete_comment(byPostId: String, andCommentId: String) {
    let ref = FIRDatabase.database().reference()
    
    ref.child("posts/\(byPostId)/comments/\(andCommentId)").removeValue()
}


/******** CloudMine *********/
func cloudMine_register_user(email: String, password: String) {
    
    let user = CMUser(email: email, andPassword: password)!
    
    user.createAccount { (result, error) in
        switch (result) {
        case .createSucceeded:
            // Do something with registred user
            break
        case .createFailedInvalidRequest:
            // Handle failed request error
            break
        case .createFailedDuplicateAccount:
            // Handle failed duplicated account error
            break
            
        default:
            return
        }
    }
}

func cloudMine_login_user(email: String, password: String) {
    
    let user = CMUser(email: email, andPassword: password)!
    
    user.login { (result, error) in
        switch (result) {
        case .loginSucceeded:
            // Do something with logged in user
            break
        case .loginFailedIncorrectCredentials:
            // Handle error
            break
            
        default:
            return
        }
    }
}

func cloudMine_create_post(title: String, message: String) {
    
    let post = CloudMinePost()!
    
    post.title = title
    post.message = message
    
    post.save { (response) in
        if let response = response {
            if let (id, status) = response.uploadStatuses.first {
                // Do something with posts id
            } else {
                // Handle error
            }
        }
    }
    
}

func cloudMine_create_comment(inPost: CloudMinePost, message: String) {
    
    let comment = CloudMineComment()!
    
    comment.message = message
    
    if let comments = inPost.comments {
        inPost.comments!.append(comment)
    } else {
        inPost.comments = [CloudMineComment]()
        inPost.comments?.append(comment)
    }
    
    inPost.save { (response) in
        if let response = response {
            if let (id, status) = response.uploadStatuses.first {
                // Do something with posts id
            } else {
                // Handle error
            }
        }
    }
}

// This'll get posts with comments
func cloudMine_get_posts(_ callback: @escaping (_ posts: [CloudMinePost]?) -> Void) {
    let store = CMStore.default()
    
    store?.allObjects(of: CloudMinePost.self, additionalOptions: nil, callback: { (response) in
        if let posts = response?.objects as? [CloudMinePost] {
            callback(posts) // Or add to scope // Räkna inte denna
        } else {
            // Handle error
        }
    })
}

func cloudMine_update_comment(comment: CloudMineComment, message: String) {
    comment.message = message
    
    comment.save { (response) in
        if let response = response {
            if let (id, status) = response.uploadStatuses.first {
                // Do something with comments id
            } else {
                // Handle error
            }
        }
    }
}

func cloudMine_delete_comment(fromPost: CloudMinePost, comment: CloudMineComment) {
    if fromPost.comments == nil {
        return
    }
    
    guard let index = fromPost.comments!.index(where: { (c) -> Bool in
        return c.objectId == comment.objectId
    }) else {
        return
    }
    
    fromPost.comments!.remove(at: index)
    
    fromPost.save { (response) in
        if let response = response {
            if let (id, status) = response.uploadStatuses.first {
                // Do something
            } else {
                // Handle error
            }
        }
    }
}

