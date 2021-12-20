//
//  AddPlacesVC.swift
//  FoursquareClone
//
//  Created by Farid Rzayev on 30.11.21.
//

import UIKit

class AddPlacesVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeAtmosphereText: UITextField!
    @IBOutlet weak var placetypeText: UITextField!
    @IBOutlet weak var placeimageView: UIImageView!
    @IBOutlet weak var placenameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = true
        let hideKey = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKey)
        
        placeimageView.isUserInteractionEnabled = true
        let imagePickerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        placeimageView.addGestureRecognizer(imagePickerTapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func imageTap(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeimageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func nextButtonClicked(_ sender: Any) {
        if placetypeText.text != "" && placeAtmosphereText.text != "" && placenameText.text != ""{
            if let img = placeimageView.image{
        let placeModel = PlaceModel.shared
        placeModel.PlaceNameModel = placenameText.text!
        placeModel.PlaceTypeModel = placetypeText.text!
        placeModel.PlaceAtmosphereModel = placeAtmosphereText.text!
        placeModel.PlaceImageModel = img
        performSegue(withIdentifier: "toMapVC", sender: nil)
            }
        }
    }

    
}
