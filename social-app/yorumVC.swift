//
//  yorumVC.swift
//  social-app
//
//  Created by @unknown on 18.12.2018.
//

import UIKit
import Firebase
class yorumVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
   
    @IBOutlet weak var ppImage: UIImageView!
    static var yorumlar = [String:[Any]]()
    @IBOutlet weak var yorumYapText: UITextView!
    static var userpp = ""
    static var imageId = ""
    static var userMail = [String]()
    static var yorum = [String]()
    static var yorumSahibiResmi = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {

        super.viewDidLoad()
        ppImage.setRounded()
        if myProfileVC.userProfileImage != ""
        {
            ppImage.sd_setImage(with: URL(string: myProfileVC.userProfileImage))

        }
        tableView.delegate = self
        tableView.dataSource = self
       
        getYorum(dic: yorumVC.yorumlar)
        self.tableView.reloadData()
    
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.xy), name: NSNotification.Name(rawValue: "newImage"), object: nil)
        
    }
    @objc func xy()
    {
        getYorum(dic: yorumVC.yorumlar)
        self.tableView.reloadData()
    }
    func getYorum(dic:Dictionary<String,Array<Any>>)
    {
        yorumVC.userMail.removeAll(keepingCapacity: false)
        yorumVC.yorum.removeAll(keepingCapacity: false)
        yorumVC.yorumSahibiResmi.removeAll(keepingCapacity: false)
        let x = dic as NSDictionary
   
        if let sozluk = x[yorumVC.imageId]
        {

           
            var sozluk1 = sozluk as! [Any]
            for i in 0...((sozluk as AnyObject).count!-1)
            {
   
                let temp = sozluk1[i] as! NSDictionary
                yorumVC.userMail.append(temp["userMail"]! as! String)
                yorumVC.yorum.append(temp["yorum"]! as! String)
                yorumVC.yorumSahibiResmi.append(temp["yorumSahibiResmi"]! as! String)

                
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return yorumVC.yorum.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let boldText  = yorumVC.userMail[indexPath.row]
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        let normalText = "\n"+yorumVC.yorum[indexPath.row]
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! yorumCell
        cell.yorumText.attributedText = attributedString
        cell.profileImage.sd_setImage(with: URL(string: yorumVC.yorumSahibiResmi[indexPath.row]))

        return cell
    }
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField == yorumYapText {
            yorumYapText.text = ""
        }
    }

    
    @IBAction func shareButtonClicked(_ sender: Any) {

        let databaseRef = Database.database().reference()
        var profilresmi = yorumVC.userpp
        
        if yorumVC.userpp == ""
        {
            profilresmi = "https://firebasestorage.googleapis.com/v0/b/social-app-d08b4.appspot.com/o/media%2FuserImage.png?alt=media&token=741b87c1-6336-4fe9-bcda-edbb924d54ed"

        }
        let yorum = ["yorumSahibiResmi":profilresmi,"userMail":Auth.auth().currentUser!.email!,"yorum":yorumYapText.text!]as[String: Any]
       
    databaseRef.child("users").child(imageDetailsVC.userid).child("post").child(imageDetailsVC.imageid).child("yorum").childByAutoId().setValue(yorum)
       
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:"
        let utcTime = formatter.string(from: date)
        
        let bildirim = ["olay":("'"+(Auth.auth().currentUser?.email)!+"'")+" resmine yorum yaptı","tarih":utcTime,"sImage":imageDetailsVC.selectedImage,"userImage":myProfileVC.userProfileImage]
        
        databaseRef.child("users").child(imageDetailsVC.userid).child("bildirim").child("durum").setValue("1")
        databaseRef.child("users").child(imageDetailsVC.userid).child("bildirim").childByAutoId().setValue(bildirim)
        
        yorumYapText.text = ""
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "imageDetailsTab")
        self.present(main!, animated: false, completion: nil)
    }
    
    
}
