//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Farid Rzayev on 29.11.21.
//

import UIKit
import Parse

class PlacesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedID = ""

    @IBOutlet weak var placesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTableView.delegate = self
        placesTableView.dataSource = self
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addAction))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOut))
        
        getDatafromParse()

        // Do any additional setup after loading the view.
    }
    
    @objc func addAction(){
        performSegue(withIdentifier: "toAddPlacesVC", sender: nil)
    }
    @objc func logOut(){
        PFUser.logOutInBackground { err in
            if err != nil {
                let alert = UIAlertController(title: "Error!", message: err?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeNameArray.count
    }
    func getDatafromParse(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if objects != nil{
                    self.placeIdArray.removeAll()
                    self.placeNameArray.removeAll()
                for object in objects! {
                    if let placeName = object.object(forKey: "name") as? String{
                        if let placeId = object.objectId {
                            self.placeNameArray.append(placeName)
                            self.placeIdArray.append(placeId)
                        }
                        
                    }
                    
                }
                    self.placesTableView.reloadData()
                }
            }
            
        }
    }
    func makeAlert(titleInput : String, messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destination = segue.destination as! DetailsVC
            destination.chosenID = selectedID
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = placeIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let query = PFQuery(className: "Places")
            query.whereKey("objectId", equalTo: placeIdArray[indexPath.row])
            query.findObjectsInBackground { objects, error in
                    if let holder = objects {
                        for object in holder {
                            object.deleteEventually()
                            self.placeIdArray.remove(at: indexPath.row)
                            self.placeNameArray.remove(at: indexPath.row)
                            self.placesTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)

                            
                        }
                        DispatchQueue.main.async {
                                            self.placesTableView.reloadData()
                                        }
                    }
            
            }
        }
    }

}
