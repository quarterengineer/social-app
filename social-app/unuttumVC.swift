//
//  unuttumVC.swift
//  social-app
//
//  Created by @unknown on 8.01.2019.
//

import UIKit
import Firebase
import FirebaseAuth
class unuttumVC: UIViewController {

    @IBOutlet weak var mailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor .orange
    }
    

    @IBAction func unuttumButtonClicked(_ sender: Any)
    {
        Auth.auth().sendPasswordReset(withEmail: mailText.text!) { (error) in
            if error != nil
            {
                
                let alert = UIAlertController(title: "Hata", message: "mail adresiniz yanlis lutfen tekrar deneyiniz!", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                let alert = UIAlertController(title: "Basarili", message: "Mail adresininize sifirlama linki gonderdik.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    
    }
}
