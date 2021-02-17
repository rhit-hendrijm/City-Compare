//
//  CompareViewController.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/16/21.
//

import UIKit
import Firebase

class CompareViewController: UIViewController {
    
    @IBOutlet weak var cityOneLabel: UILabel!
    @IBOutlet weak var cityTwoLabel: UILabel!
    @IBOutlet weak var rentOneLabel: UILabel!
    @IBOutlet weak var rentTwoLabel: UILabel!
    @IBOutlet weak var homePriceOneLabel: UILabel!
    @IBOutlet weak var homePriceTwoLabel: UILabel!
    @IBOutlet weak var energyBillOneLabel: UILabel!
    @IBOutlet weak var energyBillTwoLabel: UILabel!
    @IBOutlet weak var phoneBillOneLabel: UILabel!
    @IBOutlet weak var phoneBillTwoLabel: UILabel!
    @IBOutlet weak var gasOneLabel: UILabel!
    @IBOutlet weak var gasTwoLabel: UILabel!
    @IBOutlet weak var nightLifeOneLabel: UILabel!
    @IBOutlet weak var nightLifeTwoLabel: UILabel!
    @IBOutlet weak var foodOneLabel: UILabel!
    @IBOutlet weak var foodTwoLabel: UILabel!
    @IBOutlet weak var diversityOneLabel: UILabel!
    @IBOutlet weak var diversityTwoLabel: UILabel!
    
    var cityOne: City?
    var cityTwo: City?
    var cityOneRef: DocumentReference!
    var cityTwoRef: DocumentReference!
    var CityOneListener: ListenerRegistration!
    var CityTwoListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Comparison", style: .plain, target: self, action: #selector(saveComparison))
        cityOneRef = Firestore.firestore().collection("Cities").document("Dallas")
        cityTwoRef = Firestore.firestore().collection("Cities").document("Dallas")
        
    }
    
    @objc func saveComparison() {
        Firestore.firestore().collection("Comparisons").addDocument(data: ["City One" : cityOne?.name as Any,
                                                                           "City Two" : cityTwo?.name as Any,
                                                                           "created" : Timestamp.init(),
                                                                           "user" : Auth.auth().currentUser?.uid as Any])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CityOneListener = cityOneRef.addSnapshotListener({ (documentSnapshot, error) in
            if let error = error {
                print("Error getting city one \(error)")
                return
            }
            if !documentSnapshot!.exists {
                print("Might go back to the list since someone else deleted thid document")
                return
            }
            self.cityOne = City(documentSnapshot: documentSnapshot!)
            self.updateCityOne()
        })
        CityTwoListener = cityTwoRef.addSnapshotListener({ (documentSnapshot, error) in
            if let error = error {
                print("Error getting city one \(error)")
                return
            }
            if !documentSnapshot!.exists {
                print("Might go back to the list since someone else deleted thid document")
                return
            }
            self.cityTwo = City(documentSnapshot: documentSnapshot!)
            self.updateCityTwo()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CityOneListener.remove()
        CityTwoListener.remove()
    }
    
    func updateCityOne() {
        cityOneLabel.text = cityOne?.name
        rentOneLabel.text = String(cityOne!.rent)
        homePriceOneLabel.text = String(cityOne!.homePrice)
        energyBillOneLabel.text = String(cityOne!.energyBill)
        phoneBillOneLabel.text = String(cityOne!.phoneBill)
        gasOneLabel.text = String(cityOne!.gas)
        nightLifeOneLabel.text = String(cityOne!.nightLife)
        foodOneLabel.text = String(cityOne!.food)
        diversityOneLabel.text = String(cityOne!.diversity)
    }
    
    func updateCityTwo() {
        cityTwoLabel.text = cityTwo?.name
        rentTwoLabel.text = String(cityTwo!.rent)
        homePriceTwoLabel.text = String(cityTwo!.homePrice)
        energyBillTwoLabel.text = String(cityTwo!.energyBill)
        phoneBillTwoLabel.text = String(cityTwo!.phoneBill)
        gasTwoLabel.text = String(cityTwo!.gas)
        nightLifeTwoLabel.text = String(cityTwo!.nightLife)
        foodTwoLabel.text = String(cityTwo!.food)
        diversityTwoLabel.text = String(cityTwo!.diversity)
    }
    
    
    @IBAction func pressedChangeCityOne(_ sender: Any) {
    }
    
    @IBAction func pressedChangeCityTwo(_ sender: Any) {
    }
}
