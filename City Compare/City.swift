//
//  City.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/15/21.
//

import Foundation
import Firebase

class City {
    var id: String?
    var diversity: Double
    var energyBill: Double
    var food: Double
    var gas: Double
    var homePrice: Double
    var nightLife: Double
    var phoneBill: Double
    var rent: Double
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.diversity = Double((data["Diversity"] as! Array<Double>).reduce(0, +)) / Double((data["Diversity"] as! Array<Double>).count)
        self.energyBill = Double((data["Energy Bill"] as! Array<Double>).reduce(0, +)) / Double((data["Energy Bill"] as! Array<Double>).count)
        self.food = Double((data["Food"] as! Array<Double>).reduce(0, +)) / Double((data["Food"] as! Array<Double>).count)
        self.gas = Double((data["Gas"] as! Array<Double>).reduce(0, +)) / Double((data["Gas"] as! Array<Double>).count)
        self.homePrice = Double((data["Home Price"] as! Array<Double>).reduce(0, +)) / Double((data["Home Price"] as! Array<Double>).count)
        self.nightLife = Double((data["Night Life"] as! Array<Double>).reduce(0, +)) / Double((data["Night Life"] as! Array<Double>).count)
        self.phoneBill = Double((data["Phone Bill"] as! Array<Double>).reduce(0, +)) / Double((data["Phone Bill"] as! Array<Double>).count)
        self.rent = Double((data["Rent"] as! Array<Double>).reduce(0, +)) / Double((data["Rent"] as! Array<Double>).count)
    }
}

