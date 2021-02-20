//
//  CityTableViewController.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/19/21.
//

import UIKit
import Firebase
import FirebaseAuth

class CityTableViewController: UITableViewController {
    let cityCellIdentifier = "CityCell"
    var cityRef = Firestore.firestore().collection("Cities")
    var cities = [City]()
    var cityListener: ListenerRegistration!
    let goBack = "goBackSegue"
    var city = ""
    var isCityOn: Bool!
    var cityOneRef: DocumentReference!
    var cityTwoRef: DocumentReference!
    var isReview = false
    
    
    func startListening() {
        if cityListener != nil {
            cityListener.remove()
        }
        var query = cityRef.limit(to: 50)
        cityListener = query.addSnapshotListener({ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.cities.removeAll()
                querySnapshot.documents.forEach { (docSnapshot) in
                    self.cities.append(City(documentSnapshot: docSnapshot))
                }
                self.tableView.reloadData()
            } else {
                print("error: \(error)")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListening()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].id
//        print(city)
        print(cities[indexPath.row].id!)
//        city = cities[indexPath.row].id!
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cityListener.remove()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goBack {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                city = cities[indexPath.row].id!
                let controller = segue.destination as! CompareViewController
                if (isCityOn) {
                    print(city)
                    controller.cityOneName = city
                    controller.cityOneRef = Firestore.firestore().collection("Cities").document(city)
                    controller.cityTwoRef = cityTwoRef
                } else {
                    print(city)
                    controller.cityTwoName = city
                    controller.cityTwoRef = Firestore.firestore().collection("Cities").document(city)
                    controller.cityOneRef = cityOneRef
                }

            }
        }
    }
}
