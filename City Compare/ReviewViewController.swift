//
//  ReviewViewController.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/17/21.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var homePriceTextField: UITextField!
    @IBOutlet weak var energyBillTextField: UITextField!
    @IBOutlet weak var phoneBillTextField: UITextField!
    @IBOutlet weak var gasTextField: UITextField!
    @IBOutlet weak var nightLifeTextField: UITextField!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var diversityTextField: UITextField!
    
    var cityRef: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityRef = Firestore.firestore().collection("Cities").document("Dallas")
        
    }
    
    @IBAction func pressedSubmitReview(_ sender: Any) {
        cityRef.updateData(["Rent" : FieldValue.arrayUnion([rentTextField.text]),
                            "Home Price" : FieldValue.arrayUnion([homePriceTextField.text]),
                            "Energy Bill" : FieldValue.arrayUnion([energyBillTextField.text]),
                            "Phone Bill" : FieldValue.arrayUnion([phoneBillTextField.text]),
                            "Gas" : FieldValue.arrayUnion([gasTextField.text]),
                            "Night Life" : FieldValue.arrayUnion([nightLifeTextField.text]),
                            "Food" : FieldValue.arrayUnion([foodTextField.text]),
                            "Diversity" : FieldValue.arrayUnion([diversityTextField.text])])
        self.dismiss(animated: true, completion: nil)
    }
    
}
