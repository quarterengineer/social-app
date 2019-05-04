//
//  signUpVC.swift
//  social-app
//
//  Created by @unknown on 5.12.2018.
//

import UIKit
import Firebase
import FirebaseAuth
class signUpVC: UIViewController {
    
    @IBOutlet weak var signInLabelClicked: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var nameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.signInClickedFunc))
        signInLabelClicked.isUserInteractionEnabled = true
        signInLabelClicked.addGestureRecognizer(tap)
    }
    @objc func signInClickedFunc(sender:UITapGestureRecognizer) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "signIn")
        self.present(main!, animated: false, completion: nil)
    }

    

    @IBAction func signUpClicked(_ sender: Any) {
        if (emailText.text != "" && passwordText.text != "")
        {   
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!)
            { (userdata, error) in
                if error != nil
                {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                   
                    let databaseRef = Database.database().reference();
                    let post = ["image":"https://firebasestorage.googleapis.com/v0/b/social-app-d08b4.appspot.com/o/media%2FuserImage.png?alt=media&token=741b87c1-6336-4fe9-bcda-edbb924d54ed"]
                    databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("userImage").setValue(post)
                    
                    let alert = UIAlertController(title: "Success", message: "", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    UserDefaults.standard.set(self.emailText.text, forKey: "user")
                    UserDefaults.standard.synchronize()
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)

                }
                
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Username/Password?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

}
