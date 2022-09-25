//
//  ListTableViewController.swift
//  AgostinhoDanielaLuizViniciusWesley2
//
//  Created by Agostinho José Schlindwein on 24/09/22.
//

import UIKit
import Firebase

final class ListTableViewController: UITableViewController {

    // MARK: - Properties
    private let collection = "toyDonationList"
    private var toyDonationList: [DonationItem] = []
    private lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    var firestoreListener: ListenerRegistration!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadToyDonationList()
    }
    
    // MARK: - Methods

    private func loadToyDonationList() {
        firestoreListener = firestore
                            .collection(collection)
                            .order(by: "name", descending: false)
//                                .limit(to: 20)
                            .addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
                                if let error = error {
                                    print(error)
                                } else {
                                    guard let snapshot = snapshot else { return }
                                    print("Total de documentos alterados:", snapshot.documentChanges.count)
                                    if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                                        self.showItemsFrom(snapshot: snapshot)
                                    }
                                }
                            })
    }
    
    private func showItemsFrom(snapshot: QuerySnapshot) {
        toyDonationList.removeAll()
        for document in snapshot.documents {
            let id = document.documentID
            let data = document.data()
            let name = data["name"] as? String ?? "---"
            let telephone = data["telephone"] as? Int ?? 0
            let donationItem = DonationItem(id: id, name: name, telephone: telephone)
            toyDonationList.append(donationItem)
        }
        tableView.reloadData()
    }
    
    private func showAlertForItem(_ item: DonationItem?) {
        let alert = UIAlertController(title: "Toy", message: "Give us a contact number and the name of the toy you want to donate", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
            textField.text = item?.name
        }
        alert.addTextField { textField in
            textField.placeholder = "Telephone"
            textField.keyboardType = .numberPad
            textField.text = item?.telephone.description
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let name = alert.textFields?.first?.text,
                  let telephoneText = alert.textFields?.last?.text,
                  let telephone = Int(telephoneText) else {return}
            
            let data: [String: Any] = [
                "name": name,
                "telephone": telephone
            ]
            
            if let item = item {
                //Edição
                self.firestore.collection(self.collection).document(item.id).updateData(data)
            } else {
                //Criação
                self.firestore.collection(self.collection).addDocument(data: data)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toyDonationList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let donationItem = toyDonationList[indexPath.row]
        cell.textLabel?.text = donationItem.name
        cell.detailTextLabel?.text = "\(donationItem.telephone)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let donationItem = toyDonationList[indexPath.row]
        showAlertForItem(donationItem)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let donationItem = toyDonationList[indexPath.row]
            firestore.collection(collection).document(donationItem.id).delete()
        }
    }
    
    // MARK: - IBActions
    @IBAction func addItem(_ sender: Any) {
        showAlertForItem(nil)
    }
}



