//
//  messageVC.swift
//  social-app
//
//  Created by @unknown on 6.01.2019.
//

import UIKit

class notificationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    
    @IBAction func backButtonClicked(_ sender: Any)
    {
        let imageDetails = self.storyboard?.instantiateViewController(withIdentifier: "profilebak1") as! UINavigationController
        self.present(imageDetails, animated: false, completion: nil)
    }
    


}
