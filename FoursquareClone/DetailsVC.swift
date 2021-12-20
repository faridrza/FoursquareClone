//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Farid Rzayev on 30.11.21.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {
    
    var chosenID = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    

    @IBOutlet weak var detailsMapKitView: MKMapView!
    @IBOutlet weak var detailsplaceAtmosphere: UILabel!
    @IBOutlet weak var detailsplaceType: UILabel!
    @IBOutlet weak var detailsPlacename: UILabel!
    @IBOutlet weak var detailsImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsMapKitView.delegate = self
        getDatafromParse()
        
        // Do any additional setup after loading the view.
    }
    
    func getDatafromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenID)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                let alert = UIAlertController(title: "error", message: "Server error!", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if objects != nil {
                    if objects!.count > 0{
                    let chosenObject = objects![0]
                        if let placeNamed = chosenObject.object(forKey: "name") as? String{
                            self.detailsPlacename.text = placeNamed
                        }
                        if let placeType = chosenObject.object(forKey: "type") as? String{
                            self.detailsplaceType.text = placeType
                        }
                        if let placeAtmosphere = chosenObject.object(forKey: "atnosphere") as? String{
                            self.detailsplaceAtmosphere.text = placeAtmosphere
                        }
                        if let placeLatitude = chosenObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                                
                            }
                        }
                        if let placeLongitude = chosenObject.object(forKey: "longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        if let imageData = chosenObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                
                                if error == nil {
                                    if data != nil {
                                        self.detailsImage.image = UIImage(data: data!)
                                    }
                                }
                                
                            }
                        }
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detailsMapKitView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsPlacename.text!
                        annotation.subtitle = self.detailsplaceType.text!
                        self.detailsMapKitView.addAnnotation(annotation)
                    }
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name = self.detailsPlacename.text!
                        
                        let launchOption = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
                        mapItem.openInMaps(launchOptions: launchOption)
                    }
                }
            }
        }
    }

}
