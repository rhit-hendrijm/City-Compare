//
//  City.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/15/21.
//

import Foundation
import Firebase

class City {
    var name: String
    var id: String?
    var diversity: Array<Int>
    var energyBill: Array<Int>
    var food: Array<Int>
    var gas: Array<Int>
    var homePrice: Array<Int>
    var nightLife: Array<Int>
    var phoneBill: Array<Int>
    var rent: Array<Int>
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.name = data["Name"] as! String
        self.diversity = data["Diversity"] as! Array<Int>
        self.energyBill = data["Energy Bill"] as! Array<Int>
        self.food = data["Food"] as! Array<Int>
        self.gas = data["Gas"] as! Array<Int>
        self.homePrice = data["Home Price"] as! Array<Int>
        self.nightLife = data["Night Life"] as! Array<Int>
        self.phoneBill = data["Phone Bill"] as! Array<Int>
        self.rent = data["Rent"] as! Array<Int>
    }
}
