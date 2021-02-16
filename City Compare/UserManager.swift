//
//  UserManager.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/15/21.
//

import Foundation
import Firebase

let kCollectionUsers = "Users"
let kKeyName = "name"

class UserManager {
    
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    
    static let shared = UserManager()
    private init() {
        _collectionRef = Firestore.firestore().collection(kCollectionUsers)
    }
    
    //create
    func addNewUserMaybe(uid: String, name: String?, photoUrl: String?) {
        let userRef = _collectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user: \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("There is already a user object for this auth user. Do nothing")
                    return
                } else {
                    print("Creating as user with document id \(uid)")
                    userRef.setData([
                        kKeyName : name ?? "",
                    ])
                }
            }
        }
    }
    
    //read
    func beginListening(uid: String, changeListener: (() -> Void)?) {
        stopListening()
        let userRef = _collectionRef.document(uid)
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error listening for user: \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                self._document = documentSnapshot
                changeListener?()
            }
        }
    }
    func stopListening() {
        _userListener?.remove()
    }
    
    //update
    func updateName(name: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeyName: name
        ])
    }
//    func updatePhotoUrl(photoUrl: String) {
//        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
//        userRef.updateData([
//            kKeyPhotoUrl: photoUrl
//        ])
//    }
    
    //no delete
    
    //getters
    var name: String {
        if let value = _document?.get(kKeyName) {
            return value as! String
        }
        return ""
    }
    
//    var photoUrl: String {
//        if let value = _document?.get(kKeyPhotoUrl) {
//            return value as! String
//        }
//        return ""
//    }
}
