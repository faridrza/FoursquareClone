//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Farid Rzayev on 29.11.21.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user , errors  in
                if errors != nil {
                    self.makeAlert(titleInput: "ERROR", messageInput: errors?.localizedDescription ?? "Server Error" )
                }
                else{

                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
                
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Please input your username and password!")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Server Error")
                }
                else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Please input your username and password!")
        }
    }
    
    func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

