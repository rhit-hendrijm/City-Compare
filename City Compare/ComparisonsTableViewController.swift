//
//  ComparisonsTableViewController.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/15/21.
//

import UIKit
import Firebase

class ComparisonsTableViewController: UITableViewController {
    let comparisonCellIdentifier = "ComparisonCell"
    let detailSegueIdentifier = "DetailSegue"
    var comparisonsRef: CollectionReference!
    var comparisonsListener: ListenerRegistration!
    var authStateListenerHandle: AuthStateDidChangeListenerHandle!
//    var isShowingallPhotos = true
    var storageRef = StorageReference()
    var docId = ""
    
    
    var comparisons = [Comparison]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "City Compare"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
        comparisonsRef = Firestore.firestore().collection("Comparisons")
        
    }
    
    @objc func showMenu() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
        alertController.addAction(UIAlertAction(title: "Add New Comparison",
                                                style: .default) { (action) in
            self.showAddNewComparison()
        })

        alertController.addAction(UIAlertAction(title: "Leave a Review",
                                                style: .default) { (action) in
            self.showLeaveReviewDialog()
        })
        
        alertController.addAction(UIAlertAction(title: "Sign Out",
                                                style: .default) { (action) in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Sign out error")
            }
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authStateListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if (Auth.auth().currentUser == nil) {
                print("There is no user")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("You are signed in")
            }
        })
        
        if (Auth.auth().currentUser == nil) {
            print("no user. go back to login")
        } else {
            print("already signed in")
        }
        
        startListening()
    }
    
    func startListening() {
        if (comparisonsListener != nil) {
            comparisonsListener.remove()
        }
        let query = comparisonsRef.order(by: "created", descending: true).limit(to: 50).whereField("user", isEqualTo: Auth.auth().currentUser!.uid)
        comparisonsListener = query.addSnapshotListener({ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.comparisons.removeAll()
                querySnapshot.documents.forEach { (documentSnapshot) in
                    self.comparisons.append(Comparison(documentSnapshot: documentSnapshot))
                }
                self.tableView.reloadData()
            } else {
                print("Error getting photos \(error!)")
                return
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        comparisonsListener.remove()
        Auth.auth().removeStateDidChangeListener(authStateListenerHandle)
    }
    
    @objc func showAddNewComparison() {
        self.performSegue(withIdentifier: "ShowCompareSegue", sender: self)
    }
    
    @objc func showLeaveReviewDialog() {
        self.performSegue(withIdentifier: "showReviewSegue", sender: self)
    }
    
    
//    @objc func showAddPhotoDialog() {
//        let alertController = UIAlertController(title: "Create a new photo", message: "", preferredStyle: .alert)
//
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Title"
//        }
//
////        alertController.addTextField { (textField) in
////            textField.placeholder = "Photo URL"
////        }
//
//        alertController.addAction(UIAlertAction(title: "Cancel",
//                                                style: .cancel,
//                                                handler: nil))
//        alertController.addAction(UIAlertAction(title: "Upload Photo",
//                                                style: UIAlertAction.Style.default) { (action) in
//            let titleTextField = alertController.textFields![0] as UITextField
////            let photoURLTextField = alertController.textFields![1] as UITextField
//            //            print(titleTextField.text!)
//            //            print(photoURLTextField.text!)
//            //            let newPhoto = Photo(title: titleTextField.text!, photoURL: photoURLTextField.text!)
//            //            self.photos.insert(newPhoto, at: 0)
//            //            self.tableView.reloadData()
//            let documentRef = self.photosRef.addDocument(data: [
//                "title": titleTextField.text!,
////                "photoURL": photoURLTextField.text!,
//                "created": Timestamp.init(),
//                "author": Auth.auth().currentUser!.uid
//
//            ])
//
//            self.docId = documentRef.documentID
//            self.storageRef = Storage.storage().reference().child("Photos").child(self.docId)
//
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.allowsEditing = true
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePickerController.sourceType = .camera
//            } else {
//                imagePickerController.sourceType = .photoLibrary
//            }
//            self.present(imagePickerController, animated: true, completion: nil)
//
//
//        })
//        present(alertController, animated: true, completion: nil)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comparisons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: comparisonCellIdentifier, for: indexPath)
        cell.textLabel?.text = "\(comparisons[indexPath.row].cityOne) vs \(comparisons[indexPath.row].cityTwo)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let comparison = comparisons[indexPath.row]
        return Auth.auth().currentUser!.uid == comparison.user
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            photos.remove(at: indexPath.row)
            //            tableView.reloadData()
            let comparisonToDelete = comparisons[indexPath.row]
            comparisonsRef.document(comparisonToDelete.id!).delete()
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == detailSegueIdentifier {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                //                (segue.destination as! PhotoDetailViewController).photo = photos[indexPath.row]
//                (segue.destination as! PhotoDetailViewController).photoRef = photosRef.document(photos[indexPath.row].id!)
//            }
//        }
//    }
}
