//
//  Comparison.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/15/21.
//

import Foundation
import Firebase

class Comparison {
    var user: String
    var id: String?
    var cityOne: String
    var cityTwo: String
    
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.user = data["user"] as! String
        self.cityOne = data["City One"] as! String
        self.cityTwo = data["City Two"] as! String
    }
}
