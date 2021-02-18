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
    
    
    @IBOutlet weak var rentOneView: UIView!
    @IBOutlet weak var rentTwoView: UIView!
    @IBOutlet weak var homePriceOneView: UIView!
    @IBOutlet weak var homePriceTwoView: UIView!
    @IBOutlet weak var energyBillOneView: UIView!
    @IBOutlet weak var energyBillTwoView: UIView!
    @IBOutlet weak var phoneBillOneView: UIView!
    @IBOutlet weak var phoneBillTwoView: UIView!
    @IBOutlet weak var gasOneView: UIView!
    @IBOutlet weak var gasTwoView: UIView!
    @IBOutlet weak var nightLifeOneView: UIView!
    @IBOutlet weak var nightLifeTwoView: UIView!
    @IBOutlet weak var foodOneView: UIView!
    @IBOutlet weak var foodTwoView: UIView!
    @IBOutlet weak var diversityOneView: UIView!
    @IBOutlet weak var diversityTwoView: UIView!
    
    
    var cityOne: City?
    var cityTwo: City?
    var cityOneRef: DocumentReference!
    var cityTwoRef: DocumentReference!
    var CityOneListener: ListenerRegistration!
    var CityTwoListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Comparison", style: .plain, target: self, action: #selector(saveComparison))
//        cityOneRef = Firestore.firestore().collection("Cities").document("Dallas")
//        cityTwoRef = Firestore.firestore().collection("Cities").document("Houston")
    }
    
    @objc func saveComparison() {
        Firestore.firestore().collection("Comparisons").addDocument(data: ["City One" : cityOne?.id as Any,
                                                                           "City Two" : cityTwo?.id as Any,
                                                                           "created" : Timestamp.init(),
                                                                           "user" : Auth.auth().currentUser?.uid as Any])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cityOneRef != nil {
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
        }
        if cityTwoRef != nil {
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if CityOneListener != nil {
            CityOneListener.remove()
        }
        if CityTwoListener != nil {
            CityTwoListener.remove()
        }
    }
    
    
    @IBAction func pressedChangeCityOne(_ sender: Any) {
    }
    
    @IBAction func pressedChangeCityTwo(_ sender: Any) {
    }
    
    func updateCityOne() {
        cityOneLabel.text = cityOne?.id
        rentOneLabel.text = "$" + String(cityOne!.rent)
        homePriceOneLabel.text = "$" +  String(cityOne!.homePrice)
        energyBillOneLabel.text = "$" +  String(cityOne!.energyBill)
        phoneBillOneLabel.text = "$" +  String(cityOne!.phoneBill)
        gasOneLabel.text = "$" +  String(cityOne!.gas)
        nightLifeOneLabel.text = String(cityOne!.nightLife) + "/10"
        foodOneLabel.text = String(cityOne!.food) + "/10"
        diversityOneLabel.text = String(cityOne!.diversity) + "/10"
        updateBoxes()
    }
    
    func updateCityTwo() {
        cityTwoLabel.text = cityTwo?.id
        rentTwoLabel.text = "$" +  String(cityTwo!.rent)
        homePriceTwoLabel.text = "$" +  String(cityTwo!.homePrice)
        energyBillTwoLabel.text = "$" + String(cityTwo!.energyBill)
        phoneBillTwoLabel.text = "$" + String(cityTwo!.phoneBill)
        gasTwoLabel.text = "$" + String(cityTwo!.gas)
        nightLifeTwoLabel.text = String(cityTwo!.nightLife) + "/10"
        foodTwoLabel.text = String(cityTwo!.food) + "/10"
        diversityTwoLabel.text = String(cityTwo!.diversity) + "/10"
    }
    
    func updateBoxes() {
        if cityOne!.rent > cityTwo!.rent {
            rentOneView.backgroundColor = UIColor.green
            rentTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.rent > cityOne!.rent {
            rentTwoView.backgroundColor = UIColor.green
            rentOneView.backgroundColor = UIColor.lightGray
        } else {
            rentOneView.backgroundColor = UIColor.lightGray
            rentTwoView.backgroundColor = UIColor.lightGray
        }
        if cityOne!.homePrice > cityTwo!.homePrice {
            homePriceOneView.backgroundColor = UIColor.green
            homePriceTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.homePrice > cityOne!.homePrice {
            homePriceTwoView.backgroundColor = UIColor.green
            homePriceOneView.backgroundColor = UIColor.lightGray
        } else {
            homePriceOneView.backgroundColor = UIColor.lightGray
            homePriceTwoView.backgroundColor = UIColor.lightGray
        }
        if cityOne!.energyBill > cityTwo!.energyBill {
            energyBillOneView.backgroundColor = UIColor.green
            energyBillTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.energyBill > cityOne!.energyBill {
            energyBillTwoView.backgroundColor = UIColor.green
            energyBillOneView.backgroundColor = UIColor.lightGray
        } else {
            energyBillOneView.backgroundColor = UIColor.lightGray
            energyBillTwoView.backgroundColor = UIColor.lightGray
        }
        if cityOne!.phoneBill > cityTwo!.phoneBill {
            phoneBillOneView.backgroundColor = UIColor.green
            phoneBillTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.phoneBill > cityOne!.phoneBill {
            phoneBillTwoView.backgroundColor = UIColor.green
            phoneBillOneView.backgroundColor = UIColor.lightGray
        } else {
            phoneBillOneView.backgroundColor = UIColor.lightGray
            phoneBillTwoView.backgroundColor = UIColor.lightGray
        }
        if cityOne!.gas > cityTwo!.gas {
            gasOneView.backgroundColor = UIColor.green
            gasTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.gas > cityOne!.gas {
            gasTwoView.backgroundColor = UIColor.green
            gasOneView.backgroundColor = UIColor.lightGray
        } else {
            gasOneView.backgroundColor = UIColor.lightGray
            gasTwoView.backgroundColor = UIColor.lightGray
        }
        if cityOne!.nightLife > cityTwo!.nightLife {
            nightLifeOneView.backgroundColor = UIColor.green
            nightLifeTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.nightLife > cityOne!.nightLife {
            nightLifeTwoView.backgroundColor = UIColor.green
            nightLifeOneView.backgroundColor = UIColor.lightGray
        } else {
            nightLifeOneView.backgroundColor = UIColor.lightGray
            nightLifeTwoView.backgroundColor = UIColor.lightGray
        }
        if cityOne!.food > cityTwo!.food {
            foodOneView.backgroundColor = UIColor.green
            foodTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.food > cityOne!.food {
            foodTwoView.backgroundColor = UIColor.green
            foodOneView.backgroundColor = UIColor.lightGray
        } else {
            foodOneView.backgroundColor = UIColor.lightGray
            foodTwoView.backgroundColor = UIColor.lightGray
        }
        if cityOne!.diversity > cityTwo!.diversity {
            diversityOneView.backgroundColor = UIColor.green
            diversityTwoView.backgroundColor = UIColor.lightGray
        } else if cityTwo!.diversity > cityOne!.diversity {
            diversityTwoView.backgroundColor = UIColor.green
            diversityOneView.backgroundColor = UIColor.lightGray
        } else {
            diversityOneView.backgroundColor = UIColor.lightGray
            diversityTwoView.backgroundColor = UIColor.lightGray
        }
    }
}

