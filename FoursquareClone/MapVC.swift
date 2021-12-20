//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Farid Rzayev on 30.11.21.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager = CLLocationManager()
    var choosenLatitude = ""
    var choosenLongitude = ""
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
        super.viewDidLoad()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        

        // Do any additional setup after loading the view.
    }
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.shared.PlaceNameModel
            annotation.subtitle = PlaceModel.shared.PlaceTypeModel
            
            self.mapView.addAnnotation(annotation)
            
            self.choosenLatitude = String(coordinates.latitude)
            self.choosenLongitude = String(coordinates.longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    @objc func saveButton(){
        let placeModel = PlaceModel.shared
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.PlaceNameModel
        object["type"] = placeModel.PlaceTypeModel
        object["atmosphere"] = placeModel.PlaceAtmosphereModel
        object["latitude"] = self.choosenLatitude
        object["longitude"] = self.choosenLongitude
        
        if let imageData = placeModel.PlaceImageModel.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpeg", data: imageData)
        }
        object.saveInBackground { success, error in
            if error != nil{
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Unknown server error!")
            }
            else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
        
    }
    @objc func backButton(){
        self.dismiss(animated: true, completion: nil)
    }
    func makeAlert(titleInput : String, messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
