//
//  imageDetails.swift
//  social-app
//
//  Created by @unknown on 30.11.2018.
//

import UIKit
import SDWebImage
import Firebase

class imageDetailsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
  
    
    static var userpp = ""
    static var konum = ""
    static var selectedImage = ""
    static var selectedEmail = ""
    static var predictText = ""
    static var userid = ""
    static var imageid = ""
    static var likelbl = ""
    static var begendimi = ""
    static var comment = ""
    var imageDetails = UIImageView()
    var tempLabel = ""
    var buttonDurum = false
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var userCommentText: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageDetailsView: UIImageView!    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userEmail: UITextView!
    @IBOutlet weak var predictDetails: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myProfileVC.userImageArray.contains(imageDetailsVC.selectedImage) != true
        {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        }
        yorumVC.imageId = imageDetailsVC.imageid
        userCommentText.text = imageDetailsVC.comment
        self.buttonDurum = false
        if imageDetailsVC.begendimi == "true"
        {
            self.buttonDurum = true
            likeButton.setImage(UIImage(named: "kalp1"), for: .normal)
        }
        else
        {
            likeButton.setImage(UIImage(named: "kalp2"), for: .normal)
        }
        userProfileImg.setRounded()
        if imageDetailsVC.likelbl != "0"
        {
            self.likeLabel.text = imageDetailsVC.likelbl + " kisi begendi"
        }
        else
        {
            self.likeLabel.text = "Ilk Begenen Kisi Sen Ol"
        }
        
        self.imageDetails.sd_setImage(with: URL(string: imageDetailsVC.selectedImage))
        self.imageDetailsView.image = imageDetails.image
        self.predictDetails.text = imageDetailsVC.predictText + "₺"
        self.userEmail.text = imageDetailsVC.selectedEmail
        messageVC.selectedEmail = imageDetailsVC.selectedEmail
        
        if imageDetailsVC.userpp != " "
        {
            self.userProfileImg.sd_setImage(with: URL(string: imageDetailsVC.userpp))

        }
        userProfileImg.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(imageDetailsVC.selectUserImage))
        userProfileImg.addGestureRecognizer(gestureRecognizer)

    }

    @objc func selectUserImage()
    {
       
        let main = self.storyboard?.instantiateViewController(withIdentifier: "profilebak1")
        self.present(main!, animated: false, completion: nil)

        
    }
    @IBAction func backMain(_ sender: Any) {
        
        if imageDetailsVC.konum == "uD"
        {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "profilebak1")
            self.present(main!, animated: false, completion: nil)
            imageDetailsVC.konum = ""
        }
        else
        {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            self.present(main, animated: false, completion: nil)
        }
        
      
        
    }
 
    
    @IBAction func likeButtonClicked(_ sender: Any)
    {
        
        if self.buttonDurum != true
        {
            likeButton.setImage(UIImage(named: "kalp1"), for: .normal)
            likeLabel.text = String(Int(imageDetailsVC.likelbl)!+1) + " kisi begendi"
        }
      
        
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child(imageDetailsVC.userid).child("post").child(imageDetailsVC.imageid).child("like").child((Auth.auth().currentUser?.uid)!).setValue(imageDetailsVC.imageid)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:"
        let utcTime = formatter.string(from: date)

        let bildirim = ["olay":("'"+(Auth.auth().currentUser?.email)!+"'")+" resmini beğendi.","tarih":utcTime,"sImage":imageDetailsVC.selectedImage,"userImage":myProfileVC.userProfileImage]
  

        databaseRef.child("users").child(imageDetailsVC.userid).child("bildirim").child("durum").setValue("1")
        databaseRef.child("users").child(imageDetailsVC.userid).child("bildirim").childByAutoId().setValue(bildirim)
        
    }
    
    @IBAction func commentButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func deleteButtonClicked(_ sender: Any) {

        let databaseRef = Database.database().reference()
        
        databaseRef.child("users").child(imageDetailsVC.userid).child("post").child(imageDetailsVC.imageid).removeValue()
        
        
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.rememberUser()
    }
}
