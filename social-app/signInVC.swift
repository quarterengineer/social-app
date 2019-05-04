//
//  signInVC.swift
//  social-app
//
//  Created by @unknown on 29.10.2018.
//

import UIKit
import Firebase
import FirebaseAuth

class signInVC: UIViewController {
    
    @IBOutlet weak var sifremiUnuttum: UIButton!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signUpLabelClicked: UILabel!
    override func viewDidLoad()
    {
        sifremiUnuttum.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(signInVC.signUpClickedFunc))
        signUpLabelClicked.isUserInteractionEnabled = true
        signUpLabelClicked.addGestureRecognizer(tap)
   
    }
    @objc func signUpClickedFunc(sender:UITapGestureRecognizer) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "signUp")
        self.present(main!, animated: false, completion: nil)
    }
    static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
    @IBAction func signInClicked(_ sender: Any) {

        if emailText.text != "" && passwordText.text != ""
        {
          
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (userdata, error) in
                if error != nil
                {
                    self.sifremiUnuttum.isHidden = false
                    let alert = UIAlertController(title: "Error", message: "Parola veya Sifre Yanlis!", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                else if (Auth.auth().currentUser?.isEmailVerified)!
                {
                    UserDefaults.standard.set(self.emailText.text, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

                    delegate.rememberUser()
                }
                else
                {
                    let alert = UIAlertController(title: "Hata", message: "Hesabinizi Aktif Edin.", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    let tekrar = UIAlertAction(title: "Yeniden Gonder", style: UIAlertAction.Style.default, handler:
                    {
                        (alert: UIAlertAction!) -> Void in
                        Auth.auth().currentUser?.sendEmailVerification(completion:nil )
                    })
                    alert.addAction(tekrar)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Hata", message: "mail veya parola kismi bos birakilamaz!", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
 
}
